//
//  AvatarCreationLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 18.03.23.
//

import Foundation
import ComposableArchitecture
import SharedModels

struct AvatarCreationLogic: ReducerProtocol {
    struct State: Equatable {
        var enteredName: String = ""
        let minNameLength = 3
        var isButtonActive: Bool = false
    }
    enum Action: Equatable {
        case createAvatar
        case handleAvatarResponse(TaskResult<Avatar>)
        case nameEntered(String)
        case saveTapped
        case avatarCreated(Avatar)
        
    }
    @Dependency(\.avatarService) var avatarService
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .nameEntered(let text):
                state.enteredName = text
                state.isButtonActive = state.enteredName.count >= state.minNameLength
                return .none
            case .saveTapped:
                return .task { .createAvatar }
            case .createAvatar:
                let name = state.enteredName
                return .task {
                    await .handleAvatarResponse(TaskResult {
                        try await avatarService.createAvatar(name: name)
                    })
                }
            case .handleAvatarResponse(.success(let avatar)):
                return .task { .avatarCreated(avatar) }
            case .avatarCreated, .handleAvatarResponse:
                return .none
            }
        }
    }
}
