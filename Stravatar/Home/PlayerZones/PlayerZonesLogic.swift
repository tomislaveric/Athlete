//
//  Zones.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//
import ComposableArchitecture
import Foundation
import SharedModels

struct PlayerZonesLogic: ReducerProtocol {
    struct State: Equatable {
        var hrZones: [Zone] = []
        var isLoading: Bool = true
    }
    
    enum Action: Equatable {
        case setHRzones([Zone])
    }
    
    @Dependency(\.avatarService) var avatarService
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .setHRzones(let zones):
            state.hrZones = zones.filter { $0.type != .zone1 }
            avatarService.setup(zones: zones)
            state.isLoading = false
            return .none
        }
    }
}
