//
//  StravaConnectorLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 11.03.23.
//

import Foundation
import ComposableArchitecture
import PlayerEngine

struct StravaConnectorLogic: ReducerProtocol {
    struct State: Equatable {
        let name = "Connect to Strava"
        let amountOfActivities: Int = 5
    }
    enum Action: Equatable {
        case handleAthleteResponse(TaskResult<Profile>)
        case connectTapped
        case stravaConnected(Profile)
        case zonesFetched([Zone])
        case activitiesFetched([Activity])
        case handleHeartRateZonesResponse(TaskResult<[Zone]>)
        case handleActivitiesResponse(TaskResult<[Activity]>)
        
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .connectTapped:
                let amount = state.amountOfActivities
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
                            try await stravaApi.getActivities(amount)
                        })
                    }
                )
            case .handleActivitiesResponse(.success(let activities)):
                return .task { .activitiesFetched(activities) }
            case .handleHeartRateZonesResponse(.success(let zones)):
                return .task { .zonesFetched(zones) }
            case .handleAthleteResponse(.success(let profile)):
                return .task { .stravaConnected(profile) }
            case .stravaConnected, .zonesFetched, .activitiesFetched, .handleHeartRateZonesResponse, .handleAthleteResponse, .handleActivitiesResponse:
                return .none
            }
        }
    }
    
    @Dependency(\.stravaApi) var stravaApi
}
