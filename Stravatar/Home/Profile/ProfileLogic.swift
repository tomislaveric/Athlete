//
//  ProfileLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SkillEngine

struct ProfileLogic: ReducerProtocol {
    struct State: Equatable {
        var playerName: String?
        var playerZones: PlayerZonesLogic.State
        var isLoading: Bool = true
        var activityList = ActivitiesLogic.State()
    }
    
    enum Action: Equatable {
        case updateSkills
        case profileFetched(Profile)
        case playerZones(PlayerZonesLogic.Action)
        case setName(String?)
        case activityList(ActivitiesLogic.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.playerZones, action: /Action.playerZones) {
            PlayerZonesLogic()
        }
        Scope(state: \.activityList, action: /Action.activityList) {
            ActivitiesLogic()
        }
        Reduce { state, action in
            switch action {
            case .profileFetched(let profile):
                state.isLoading = false
                return .merge(
                    .task { .setName(profile.name) },
                    .task { .playerZones(.profileFetched) },
                    .task { .activityList(.fetchActivities) }
                )
            case .setName(let name):
                state.playerName = name
                return .none
            case .playerZones:
                return .none
            case .activityList(let action):
                switch action {
                case .skillsEarned:
                    return .task { .updateSkills }
                default: return .none
                }
            case .updateSkills:
                return .none
            }
        }
    }
}
