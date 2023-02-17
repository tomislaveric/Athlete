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
    }
    
    enum Action: Equatable {
        case profileFetched(Profile)
        case playerZones(PlayerZonesLogic.Action)
        case setName(String?)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.playerZones, action: /Action.playerZones) {
            PlayerZonesLogic()
        }
        Reduce { state, action in
            switch action {
            case .profileFetched(let profile):
                state.isLoading = false
                return .merge(
                    .init(value: .setName(profile.name)),
                    .init(value: .playerZones(.profileFetched))
                )
            case .setName(let name):
                state.playerName = name
                return .none
            case .playerZones:
                return .none
            }
        }
    }
}
