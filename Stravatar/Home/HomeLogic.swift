//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import PlayerEngine

struct HomeLogic: ReducerProtocol {
    
    struct State: Equatable {
        var profile: ProfileLogic.State
        
        var avatar: AvatarLogic.State
        var playerZones: PlayerZonesLogic.State
        var activityList = ActivitiesLogic.State()
        var text: String = ""
    }
    
    enum Action: Equatable {
        case profile(ProfileLogic.Action)
        case avatar(AvatarLogic.Action)
        case activityList(ActivitiesLogic.Action)
        case playerZones(PlayerZonesLogic.Action)
        case onAppearance
        case handleAthleteResponse(TaskResult<Profile>)
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.playerEngine) var skillEngine
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.profile, action: /Action.profile) {
            ProfileLogic()
        }
        Scope(state: \.avatar, action: /Action.avatar) {
            AvatarLogic()
        }
        Scope(state: \.activityList, action: /Action.activityList) {
            ActivitiesLogic()
        }
        Scope(state: \.playerZones, action: /Action.playerZones) {
            PlayerZonesLogic()
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
                    .task { .activityList(.fetchActivities) }
                )
            case .handleAthleteResponse(.success(let profile)):
                return .merge(
                    .task { .profile(.profileFetched(profile)) },
                    .task { .playerZones(.profileFetched) }
                )
            case .profile(let action):
                switch action {
                case .updateSkills:
                    return .task { .avatar(.skillsHud(.updateHud)) }
                default: return .none
                }
            case .handleAthleteResponse(.failure(let error)):
                dump(error)
                return .none
            case .activityList(let action):
                switch action {
                case .skillsEarned:
                    return .task { .avatar(.skillsHud(.updateHud)) }
                default: return .none
                }
            case .playerZones, .avatar:
                return .none
            }
        }
    }
}
