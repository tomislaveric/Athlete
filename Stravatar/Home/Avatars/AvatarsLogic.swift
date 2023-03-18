//
//  AvatarsLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 18.03.23.
//

import Foundation
import ComposableArchitecture
import SharedModels

struct AvatarsLogic: ReducerProtocol {
    struct State: Equatable {
        var avatarCreation = AvatarCreationLogic.State()
        var avatars: IdentifiedArrayOf<AvatarLogic.State> = []
        var fetched: [Avatar] = []
    }
    enum Action: Equatable {
        case avatarCreation(AvatarCreationLogic.Action)
        case avatar(id: AvatarLogic.State.ID, action: AvatarLogic.Action)
        case initialize
        case handleAvatarsResponse(TaskResult<[Avatar]>)
    }
    
    @Dependency(\.avatarService) var avatarService
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.avatarCreation, action: /Action.avatarCreation) {
          AvatarCreationLogic()
        }
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task {
                    await .handleAvatarsResponse(TaskResult {
                        try await avatarService.getAvatars()
                    })
                }
            case .handleAvatarsResponse(.success(let avatars)):
                state.avatars = IdentifiedArrayOf(uniqueElements: avatars.map { create(avatar: $0) })
                return .none
            case .avatarCreation(let action):
                switch action {
                case .avatarCreated(let avatar):
                    state.avatars.insert(create(avatar: avatar), at: 0)
                    return .none
                default: return .none
                }
            case .avatar, .handleAvatarsResponse:
                return .none
            }
        }.forEach(\.avatars, action: /Action.avatar) {
            AvatarLogic()
        }
    }
    
    func create(avatar: Avatar) -> AvatarLogic.State {
        return AvatarLogic.State(
            avatar: avatar,
            skillsHud: .init(avatarSkills: avatar.skills ?? []))
    }
}
