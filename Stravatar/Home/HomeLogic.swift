//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct HomeLogic: ReducerProtocol {
    
    struct State: Equatable {
        var login = LoginLogic.State()
        var profile: ProfileLogic.State
        var avatars: AvatarsLogic.State
        var text: String = ""
        var shouldShowLogin: Bool = true
    }
    
    enum Action: Equatable {
        case login(LoginLogic.Action)
        case profile(ProfileLogic.Action)
        case avatars(AvatarsLogic.Action)
        case onAppearance
        case loginActive
    }
    
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.profile, action: /Action.profile) {
            ProfileLogic()
        }
        Scope(state: \.avatars, action: /Action.avatars) {
            AvatarsLogic()
        }
        Scope(state: \.login, action: /Action.login) {
            LoginLogic()
        }
        Reduce { state, action in
            switch action {
            case .onAppearance:
                return .none
            case .avatars, .profile:
                return .none
            case .login(let action):
                switch action {
                case .userLoggedIn:
                    state.shouldShowLogin = false
                    return .none
                default:
                    return .none
                }
            case .loginActive:
                return .none
            }
        }
    }
}
