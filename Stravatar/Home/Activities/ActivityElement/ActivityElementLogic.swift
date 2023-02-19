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
        var id: Int
        var name: String?
        var skills: [Skill] = []
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
            state.skills = skillEngine.getSkillsFor(heartRates: response.data)
            return .none
        case .handleHeartRateResponse(.failure):
            state.isLoading = false
            return .none
        }
    }
}

