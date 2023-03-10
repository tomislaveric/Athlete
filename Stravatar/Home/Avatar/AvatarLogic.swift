//
//  AvatarLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 08.03.23.
//

import Foundation
import ComposableArchitecture
import PlayerEngine

struct AvatarLogic: ReducerProtocol {
    
    struct State: Equatable {
        var skillsHud: SkillsHudLogic.State
        var playerExists: Bool = false
        var enteredName: String = ""
        var player: Player?
    }
    
    enum Action: Equatable {
        case skillsHud(SkillsHudLogic.Action)
        case createPlayer
        case nameEntered(String)
        case saveNameTapped
        case playerCreated
    }
    
    @Dependency(\.playerEngine) var playerEngine
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.skillsHud, action: /Action.skillsHud) {
            SkillsHudLogic()
        }
        Reduce { state, action in
            switch action {
            case .createPlayer:
                state.player = playerEngine.createPlayer(name: state.enteredName)
                return .task { .playerCreated }
            case .nameEntered(let text):
                state.enteredName = text
                return .none
            case .saveNameTapped:
                return .task { .createPlayer }
            case .playerCreated:
                return .task { .skillsHud(.updateHud) }
            case .skillsHud:
                return .none
            }
        }
    }
}
