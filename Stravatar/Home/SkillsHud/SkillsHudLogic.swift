//
//  SkillsHudLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 27.02.23.
//

import ComposableArchitecture
import Foundation
import SharedModels

struct SkillsHudLogic: ReducerProtocol {
    struct State: Equatable {
        var avatarSkills: [Skill] = []
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerProtocol<State, Action> {
        EmptyReducer()
    }
}
