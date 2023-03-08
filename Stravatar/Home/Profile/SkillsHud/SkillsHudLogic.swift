//
//  SkillsHudLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 27.02.23.
//

import ComposableArchitecture
import SkillEngine
import Foundation

struct SkillsHudLogic: ReducerProtocol {
    struct State: Equatable {
        var playerSkills: [Skill] = []
    }
    
    enum Action: Equatable {
        case updateHud
    }
    
    @Dependency(\.skillEngine) var skillEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateHud:
            state.playerSkills = skillEngine.getPlayerSkills()
            return .none
        }
    }
}
