//
//  SkillsHudLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 27.02.23.
//

import ComposableArchitecture
import PlayerEngine
import Foundation

struct SkillsHudLogic: ReducerProtocol {
    struct State: Equatable {
        var playerSkills: [Skill] = []
    }
    
    enum Action: Equatable {
        case updateHud
    }
    
    @Dependency(\.playerEngine) var playerEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateHud:
            guard let player = playerEngine.getPlayer() else {
                return .none
            }
            state.playerSkills = player.skills
                .filter { $0.zoneType != .zone1 }
            return .none
        }
    }
}
