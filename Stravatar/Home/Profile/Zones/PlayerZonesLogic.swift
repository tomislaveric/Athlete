//
//  Zones.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//
import ComposableArchitecture
import SkillEngine
import Foundation

struct PlayerZonesLogic: ReducerProtocol {
    struct State: Equatable {
        var hrZones: [Zone]?
        var isLoading: Bool = true
    }
    
    enum Action: Equatable {
        case profileFetched
        case fetchHeartRateZones
        case handleHeartRateZonesResponse(TaskResult<[Zone]>)
        case setHRzones([Zone])
    }
    
    @Dependency(\.skillEngine) var skillEngine
    @Dependency(\.stravaApi) var stravaApi
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .profileFetched:
            return .init(value: .fetchHeartRateZones)
        case .fetchHeartRateZones:
            return .task {
                await .handleHeartRateZonesResponse(TaskResult {
                    try await stravaApi.getAthleteZones()
                })
            }
        case .handleHeartRateZonesResponse(.success(let zones)):
            state.isLoading = false
            return .init(value: .setHRzones(zones))
        case .handleHeartRateZonesResponse(.failure):
            state.isLoading = false
            return .none
        case .setHRzones(let zones):
            state.hrZones = zones
            skillEngine.setup(zones: zones)
            state.isLoading = false
            return .none
        }
    }
}
