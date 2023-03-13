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
        case handlePlayerResponse(TaskResult<Player?>)
        case handlePlayerCreatedResponse(TaskResult<Player>)
        case initialize
        case createPlayer
        case nameEntered(String)
        case saveNameTapped
        case playerCreated
        case editName
        case updateNameTapped
        case updateName
        case updateHud
    }
    
    @Dependency(\.playerEngine) var playerEngine
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.skillsHud, action: /Action.skillsHud) {
            SkillsHudLogic()
        }
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task {
                    await .handlePlayerResponse(TaskResult {
                        try await playerEngine.getPlayer()
                    })
                }
            case .createPlayer:
                let name = state.enteredName
                return .task {
                    await .handlePlayerCreatedResponse(TaskResult {
                        try await playerEngine.createPlayer(name: name)
                    })
                }
            case .nameEntered(let text):
                state.enteredName = text
                state.isButtonActive = state.enteredName.count >= state.minNameLength
                return .none
            case .saveNameTapped:
                return .task { .createPlayer }
            case .playerCreated:
                return .task { .updateHud }
            case .editName:
                state.inEditMode = true
                return .task { .updateHud }
            case .updateNameTapped:
                state.inEditMode = false
                return .task { .updateName }
            case .updateName:
                guard let id = state.player?.id else { return .none }
                let name = state.enteredName
                return .task { await .handlePlayerResponse(TaskResult {
                    try await playerEngine.update(id: id, name: name)
                })}
            case .skillsHud:
                return .none
            case .handlePlayerResponse(.success(let player)):
                state.player = player
                return .task { .updateHud }
            case .handlePlayerCreatedResponse(.success(let player)):
                state.player = player
                return .task { .playerCreated }
            case .updateHud:
                let player = state.player
                return .task { .skillsHud(.updateHud(player)) }
            case .handlePlayerResponse(.failure(let error)):
                dump(error)
                return .none
            case .handlePlayerCreatedResponse(.failure(let error)):
                dump(error)
                return .none
            }
        }
    }
}
