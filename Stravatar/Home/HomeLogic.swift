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
        var text: String = ""
        var authorizationInProgress = false
        var authorizedURL: URL? = nil
        var activities: [Activity] = []
    }
    
    enum Action: Equatable {
        case onAppearance
        case handleAthleteResponse(TaskResult<DetailedAthlete>)
        case handleActivitiesResponse(TaskResult<[DetailedActivity]>)
        case handleHeartRateZonesResponse(TaskResult<Zones>)
        case getProfileTapped
        case getActivitiesTapped
        case getHeartRateZonesTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            return .fireAndForget {
                try await stravaApi.registerTokenUpdate()
            }
        case .getProfileTapped:
            return .task {
                await .handleAthleteResponse(TaskResult {
                    try await stravaApi.getProfile()
                })
            }
        case .getActivitiesTapped:
            return .task {
                await .handleActivitiesResponse(TaskResult {
                    try await stravaApi.getActivities()
                })
            }
        case .handleActivitiesResponse(.success(let activities)):
            state.activities = activities.map { Activity(detailedActivity: $0) }
            return .none
        case .handleActivitiesResponse(.failure(let error)):
            dump(error)
            state.text = error.localizedDescription
            return .none
        case .handleAthleteResponse(.success(let athlete)):
            state.text = athlete.firstname ?? ""
            return .none
            
        case .handleAthleteResponse(.failure(let error)):
            dump(error)
            state.text = error.localizedDescription
            return .none
        case .handleHeartRateZonesResponse(.success(let zone)):
            if let zones = zone.heart_rate?.zones, let ranges = mapHeartRateZones(zoneRanges: zones) {
                skillEngine.setup(zone1: ranges[0], zone2: ranges[1], zone3: ranges[2], zone4: ranges[3], zone5: ranges[4])
            }
            state.text = "Points: \(skillEngine.getPointsFor(heartRate: 280))"
            return .none
        case .handleHeartRateZonesResponse(.failure(let error)):
            dump(error)
            return .none
        case .getHeartRateZonesTapped:
            return .task {
                await .handleHeartRateZonesResponse(TaskResult {
                    try await stravaApi.getAthleteZones()
                })
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
    
    @Dependency(\.keychainStorage) var storage
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.skillEngine) var skillEngine
    @Dependency(\.mainQueue) var mainQueue
}
