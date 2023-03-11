//
//  Zones.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//
import ComposableArchitecture
import PlayerEngine
import Foundation

struct PlayerZonesLogic: ReducerProtocol {
    struct State: Equatable {
        var hrZones: [Zone] = [
            Zone(range: 0..<1, type: .zone2),
            Zone(range: 0..<1, type: .zone3),
            Zone(range: 0..<1, type: .zone4),
            Zone(range: 0..<1, type: .zone5)
        ]
        var isLoading: Bool = true
    }
    
    enum Action: Equatable {
        case setHRzones([Zone])
    }
    
    @Dependency(\.playerEngine) var playerEngine
    @Dependency(\.stravaApi) var stravaApi
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .setHRzones(let zones):
            state.hrZones = zones.filter { $0.type != .zone1 }
            playerEngine.setup(zones: zones)
            state.isLoading = false
            return .none
        }
    }
}
