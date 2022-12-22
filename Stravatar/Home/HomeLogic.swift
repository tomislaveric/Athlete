//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import SwiftUI
import ComposableArchitecture

struct Home: ReducerProtocol {
    
    struct State: Equatable {
        var text: String = ""
    }
    
    enum Action: Equatable {
        case onAppearance
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            state.text = "Hello World"
            return .none
        }
    }
}
