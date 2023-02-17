//
//  ActivityElement.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation

struct ActivityElement: ReducerProtocol {
    struct State: Equatable, Identifiable {
        var id: Int
        var name: String?
    }
    
    enum Action: Equatable {
        case activitySelected
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .activitySelected:
            return .none
        }
    }
}

