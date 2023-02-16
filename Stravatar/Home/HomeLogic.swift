//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import StravaApi

struct Home: ReducerProtocol {
    
    struct State: Equatable {
        var playerHub: PlayerHub.State
        var activityList: ActivityList.State
        
        var text: String = ""
        var activities: [Activity] = []
        var activityStreamSets: StreamSet?
        var firstActivityId: Int? {
            activities.first?.id
        }
    }
    
    enum Action: Equatable {
        case playerHub(PlayerHub.Action)
        case activityList(ActivityList.Action)
        case onAppearance
        case handleAthleteResponse(TaskResult<DetailedAthlete>)
        case handleActivitiesResponse(TaskResult<[DetailedActivity]>)
        case handleHeartRateZonesResponse(TaskResult<Zones>)
        case handleActivityHeartRateResponse(TaskResult<StreamSet>)
        
        case getActivityHeartRateStreamTapped
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.skillEngine) var skillEngine
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.playerHub, action: /Action.playerHub) {
            PlayerHub()
        }
        Scope(state: \.activityList, action: /Action.activityList) {
            ActivityList()
        }
        Reduce { state, action in
            switch action {
                
            case .onAppearance:
                return .concatenate(
                    .fireAndForget {
                        try await stravaApi.registerTokenUpdate()
                    },
                    .task {
                        await .handleAthleteResponse(TaskResult {
                            try await stravaApi.getProfile()
                        })
                    },
                    .task {
                        await .handleHeartRateZonesResponse(TaskResult {
                            try await stravaApi.getAthleteZones()
                        })
                    },
                    .task {
                        await .handleActivitiesResponse(TaskResult {
                            try await stravaApi.getActivities()
                        })
                    }
                )
            case .handleActivitiesResponse(.success(let response)):
                let activities = response.map { Activity(id: $0.id, name: $0.name) }
                return .init(value: .activityList(.setActivities(activities)))
            
            case .handleAthleteResponse(.success(let athlete)):
                return .init(value: .playerHub(.setName(athlete.firstname )))
            
            case .handleHeartRateZonesResponse(.success(let zone)):
                guard let zones = zone.heart_rate?.zones, let ranges = mapHeartRateZones(zoneRanges: zones) else { return .none }
                return .init(value: .playerHub(.setHRzones(ranges)))
                
            case .handleActivityHeartRateResponse(.success(let streamSet)):
                state.activityStreamSets = streamSet
                guard let time = streamSet.time?.data?.last, let hrData = streamSet.heartrate?.data else { return .none }
                
                let points = hrData.map({ skillEngine.getPointsFor(heartRate: Int($0)) }).reduce(0, +)
                
                state.text = "Points: \(points)"
                return .none
            case .getActivityHeartRateStreamTapped:
                guard let id = state.firstActivityId else { return .none }
                return .task {
                    await .handleActivityHeartRateResponse(TaskResult {
                        try await stravaApi.getActivityHeartRateStream(id)
                    })
                }
            case .playerHub:
                return .none
            case .activityList:
                return .none
            case .handleHeartRateZonesResponse(.failure(let error)):
                dump(error)
                return .none
            case .handleAthleteResponse(.failure(let error)):
                dump(error)
                return .none
            case .handleActivitiesResponse(.failure(let error)):
                dump(error)
                return .none
            case .handleActivityHeartRateResponse(.failure(let error)):
                dump(error)
                return .none
            }
        }
    }
    func mapHeartRateZones(zoneRanges: [ZoneRange]) -> [Range<Int>]? {
        return zoneRanges.compactMap {
            if let min = $0.min, let max = $0.max {
                return min..<(max < min ? Int.max : max)
            }
            return nil
        }
    }
}
