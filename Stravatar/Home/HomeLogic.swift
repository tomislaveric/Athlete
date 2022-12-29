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
    }
    
    enum Action: Equatable {
        case onAppearance
        case handleAthleteResponse(TaskResult<Athlete>)
        case handleActivitiesResponse(TaskResult<[DetailedActivity]>)
        case getProfileTapped
        case getActivitiesTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            return .none
        case .getProfileTapped:
            return .task {
                await .handleAthleteResponse(TaskResult {
                    try await stravaApi.getProfile()
                })
            }
        case .getActivitiesTapped:
            return .task {
                await .handleActivitiesResponse(TaskResult {
                    try await stravaApi.getUserActivities()
                })
            }
        case .handleActivitiesResponse(.success(let activities)):
            state.text = activities.first?.name ?? ""
            return .none
        case .handleActivitiesResponse(.failure(let error)):
            state.text = error.localizedDescription
            return .none
        case .handleAthleteResponse(.success(let athlete)):
            state.text = athlete.firstname ?? ""
            return .none
            
        case .handleAthleteResponse(.failure(let error)):
            state.text = error.localizedDescription
            return .none
        }
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.mainQueue) var mainQueue
}
