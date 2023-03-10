//
//  ProfileLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import PlayerEngine

struct ProfileLogic: ReducerProtocol {
    struct State: Equatable {
        var playerName: String?
        var isLoading: Bool = true
    }
    
    enum Action: Equatable {
        case skillZonesTapped
        case updateSkills
        case profileFetched(Profile)
        case setName(String?)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .profileFetched(let profile):
                state.isLoading = false
                return .task { .setName(profile.name) }
            case .setName(let name):
                state.playerName = name
                return .none
            case .skillZonesTapped:
                return .none
            case .updateSkills:
                return .none
            }
        }
    }
}
