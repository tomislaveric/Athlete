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
        var skillsHud: SkillsHudLogic.State
        var text: String = ""
    }
    
    enum Action: Equatable {
        case profile(ProfileLogic.Action)
        case skillsHud(SkillsHudLogic.Action)
        
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
        Scope(state: \.skillsHud, action: /Action.skillsHud) {
            SkillsHudLogic()
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
                    }
                )
            case .handleAthleteResponse(.success(let profile)):
                return .task { .profile(.profileFetched(profile)) }
            case .profile(let action):
                switch action {
                case .updateSkills:
                    return .task { .skillsHud(.updateHud) }
                default: return .none
                }
            case .handleAthleteResponse(.failure(let error)):
                dump(error)
                return .none
            case .skillsHud:
                return .none
            }
        }
    }
}
