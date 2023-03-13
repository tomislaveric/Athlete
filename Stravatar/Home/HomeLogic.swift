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
        var text: String = ""
    }
    
    enum Action: Equatable {
        case profile(ProfileLogic.Action)
        case avatar(AvatarLogic.Action)
        case onAppearance
    }
    
    @Dependency(\.playerEngine) var skillEngine
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.profile, action: /Action.profile) {
            ProfileLogic()
        }
        Scope(state: \.avatar, action: /Action.avatar) {
            AvatarLogic()
        }
        Reduce { state, action in
            switch action {
            case .onAppearance:
                return .none
            case .avatar, .profile:
                return .none
            }
        }
    }
}
