//
//  ActivityElement.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation

struct ActivityElementLogic: ReducerProtocol {
    struct State: Equatable, Identifiable {
        let id = UUID()
        let activity: Activity
    }
    
    enum Action: Equatable {
        case elementTapped
        case selected(activity: Activity)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .elementTapped:
            let activity = state.activity
            return .task { .selected(activity: activity) }
        case .selected:
            return .none
        }
    }
}

