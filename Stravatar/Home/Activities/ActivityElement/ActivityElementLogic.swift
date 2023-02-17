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
        var id: Int
        var name: String?        
        var points: String?
        var isLoading = true
    }
    
    enum Action: Equatable {
        case viewAppeared
        case fetchHeartRateData
        case activitySelected
        case handleHeartRateResponse(TaskResult<ActivityHeartRate>)
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.skillEngine) var skillEngine
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .viewAppeared:
            return .init(value: .fetchHeartRateData)
        case .activitySelected:
            return .none
        case .fetchHeartRateData:
            let id = state.id
            return .task {
                await .handleHeartRateResponse(TaskResult {
                    try await stravaApi.getActivityHeartRateStream(id)
                })
            }
        case .handleHeartRateResponse(.success(let response)):
            state.isLoading = false
            state.points = "\(response.data.map { skillEngine.getPointsFor(heartRate: $0) }.reduce(0, +))"
            return .none
        case .handleHeartRateResponse(.failure):
            state.isLoading = false
            return .none
        }
    }
}

