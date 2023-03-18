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
    
    struct State: Equatable, Identifiable {
        let id = UUID()
        var avatar: Avatar
        var skillsHud: SkillsHudLogic.State
    }
    
    enum Action: Equatable {
        case skillsHud(SkillsHudLogic.Action)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.skillsHud, action: /Action.skillsHud) {
            SkillsHudLogic()
        }
        EmptyReducer()
    }
}
