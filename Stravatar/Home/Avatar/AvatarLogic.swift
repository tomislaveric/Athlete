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
        var isButtonActive: Bool = false
        let minNameLength = 3
        var inEditMode: Bool = false
    }
    
    enum Action: Equatable {
        case skillsHud(SkillsHudLogic.Action)
        case handleUpdateResponse(TaskResult<Player>)
        case initialize
        case createPlayer
        case nameEntered(String)
        case saveNameTapped
        case playerCreated
        case editName
        case updateNameTapped
        case updateName
    }
    
    @Dependency(\.playerEngine) var playerEngine
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.skillsHud, action: /Action.skillsHud) {
            SkillsHudLogic()
        }
        Reduce { state, action in
            switch action {
            case .initialize:
                state.player = playerEngine.getPlayer()
                return .task { .skillsHud(.updateHud) }
            case .createPlayer:
                state.player = playerEngine.createPlayer(name: state.enteredName)
                return .task { .playerCreated }
            case .nameEntered(let text):
                state.enteredName = text
                state.isButtonActive = state.enteredName.count >= state.minNameLength
                return .none
            case .saveNameTapped:
                return .task { .createPlayer }
            case .playerCreated:
                return .task { .skillsHud(.updateHud) }
            case .editName:
                state.inEditMode = true
                return .task { .skillsHud(.updateHud) }
            case .updateNameTapped:
                state.inEditMode = false
                return .task { .updateName }
            case .updateName:
                let name = state.enteredName
                return .task { await .handleUpdateResponse(TaskResult {
                    try playerEngine.update(name: name)
                })}
            case .skillsHud:
                return .none
            case .handleUpdateResponse(.success(let player)):
                state.player = player
                return .task { .skillsHud(.updateHud) }
            case .handleUpdateResponse:
                return .none
            }
        }
    }
}
