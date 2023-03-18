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
        var profile: ProfileLogic.State
        var avatars: AvatarsLogic.State
        var text: String = ""
    }
    
    enum Action: Equatable {
        case profile(ProfileLogic.Action)
        case avatars(AvatarsLogic.Action)
        case onAppearance
    }
    
    @Dependency(\.mainQueue) var mainQueue
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.profile, action: /Action.profile) {
            ProfileLogic()
        }
        Scope(state: \.avatars, action: /Action.avatars) {
            AvatarsLogic()
        }
        Reduce { state, action in
            switch action {
            case .onAppearance:
                return .none
            case .avatars, .profile:
                return .none
            }
        }
    }
}
