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
        case updateHud(Player?)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .updateHud(let player):
            guard let player, let skills = player.skills else { return .none }
            state.playerSkills = skills
                .filter { $0.zoneType != .zone1 }
            return .none
        }
    }
}
