//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import SkillEngine

struct HomeLogic: ReducerProtocol {
    
    struct State: Equatable {
        var profile: ProfileLogic.State
        var activityList: ActivitiesLogic.State
        
        var text: String = ""
        var activities: [Activity] = []
        var firstActivityId: Int? {
            activities.first?.id
        }
    }
    
    enum Action: Equatable {
        case profile(ProfileLogic.Action)
        case activityList(ActivitiesLogic.Action)
        case onAppearance
        case handleAthleteResponse(TaskResult<Profile>)
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.skillEngine) var skillEngine
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.profile, action: /Action.profile) {
            ProfileLogic()
        }
        Scope(state: \.activityList, action: /Action.activityList) {
            ActivitiesLogic()
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
                    .init(value: .activityList(.fetchActivities))
                )
            case .handleAthleteResponse(.success(let profile)):
                return .init(value: .profile(.profileFetched(profile)))
            case .profile:
                return .none
            case .activityList:
                return .none
            case .handleAthleteResponse(.failure(let error)):
                dump(error)
                return .none
            }
        }
    }
}
