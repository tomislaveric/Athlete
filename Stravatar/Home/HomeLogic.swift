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
            state.text = "\(zone.heart_rate?.zones?.first?.max)"
            return .none
        case .handleHeartRateZonesResponse(.failure(let error)):
            return .none
        case .getHeartRateZonesTapped:
            return .task {
                await .handleHeartRateZonesResponse(TaskResult {
                    try await stravaApi.getAthleteZones()
                })
            }
        }
    }
    
    @Dependency(\.keychainStorage) var storage
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.mainQueue) var mainQueue
}
