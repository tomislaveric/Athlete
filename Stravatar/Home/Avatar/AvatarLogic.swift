//
//  AvatarLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 08.03.23.
//

import Foundation
import ComposableArchitecture
import SharedModels

struct AvatarLogic: ReducerProtocol {
    
    struct State: Equatable {
        var skillsHud: SkillsHudLogic.State
        var playerExists: Bool = false
        var enteredName: String = ""
        var avatars: [Avatar] = []
        var currentAvatar: Avatar?
        var isButtonActive: Bool = false
        let minNameLength = 3
        var inEditMode: Bool = false
    }
    
    enum Action: Equatable {
        case skillsHud(SkillsHudLogic.Action)
        case handleAvatarsResponse(TaskResult<[Avatar]>)
        case handleAvatarResponse(TaskResult<Avatar>)
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
    
    @Dependency(\.avatarService) var avatarService
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.skillsHud, action: /Action.skillsHud) {
            SkillsHudLogic()
        }
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task {
                    await .handleAvatarsResponse(TaskResult {
                        try await avatarService.getAvatars()
                    })
                }
            case .createPlayer:
                let name = state.enteredName
                return .task {
                    await .handleAvatarResponse(TaskResult {
                        try await avatarService.createAvatar(name: name)
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
                guard let id = state.avatars.first?.id else { return .none }
                let name = state.enteredName
                return .task { await .handleAvatarResponse(TaskResult {
                    try await avatarService.update(id: id, name: name)
                })}
            case .skillsHud:
                return .none
            case .handleAvatarsResponse(.success(let player)):
                state.avatars = player
                return .task { .updateHud }
            case .handleAvatarResponse(.success(let avatar)):
                dump(avatar)
                state.currentAvatar = avatar
                return .task { .playerCreated }
            case .updateHud:
                let avatar = state.currentAvatar
                return .task { .skillsHud(.updateHud(avatar)) }
            case .handleAvatarsResponse(.failure(let error)):
                dump(error)
                return .none
            case .handleAvatarResponse(.failure(let error)):
                dump(error)
                return .none
            }
        }
    }
}
