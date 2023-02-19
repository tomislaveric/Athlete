//
//  ActivityElement.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SkillEngine

struct ActivityElementLogic: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id: Int
        let activity: Activity
        let skills: [Skill]
    }
    
    enum Action: Equatable {
        case activitySelected
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.skillEngine) var skillEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .activitySelected:
            return .none
        }
    }
}

