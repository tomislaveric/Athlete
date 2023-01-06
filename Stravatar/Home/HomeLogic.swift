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
        case getProfileTapped
        case getActivitiesTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            let storageName = Bundle.main.bundleIdentifier ?? "strava_api.oauth_token"
            return .fireAndForget {
                stravaApi.registerTokenUpdate(current: try storage.read(name: storageName)) { newToken in
                    try storage.save(name: storageName, object: newToken)
                }
            }
        case .getProfileTapped:
            return .task {
                await .handleAthleteResponse(TaskResult {
                    try await stravaApi.getDetailedAthlete()
                })
            }
        case .getActivitiesTapped:
            return .task {
                await .handleActivitiesResponse(TaskResult {
                    try await stravaApi.getAthleteDetailedActivities(params: nil)
                })
            }
        case .handleActivitiesResponse(.success(let activities)):
            state.activities = activities.map { Activity(detailedActivity: $0) }
            return .none
        case .handleActivitiesResponse(.failure(let error)):
            state.text = error.localizedDescription
            return .none
        case .handleAthleteResponse(.success(let athlete)):
            state.text = athlete.firstname ?? ""
            return .none
            
        case .handleAthleteResponse(.failure(let error)):
            dump(error)
            state.text = error.localizedDescription
            return .none
        }
    }
    
    @Dependency(\.keychainStorage) var storage
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.mainQueue) var mainQueue
}
