//
//  PlayerHub.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation

struct PlayerHub: ReducerProtocol {
    struct State: Equatable {
        var playerName: String?
        var hrZones: [Range<Int>]?
    }
    
    enum Action: Equatable {
        case setName(String?)
        case setHRzones([Range<Int>])
    }
    
    @Dependency(\.skillEngine) var skillEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .setName(let name):
            state.playerName = name
            return .none
        case .setHRzones(let ranges):
            state.hrZones = ranges
            skillEngine.setup(zone1: ranges[0], zone2: ranges[1], zone3: ranges[2], zone4: ranges[3], zone5: ranges[4])
            return .none
        }
    }
}
