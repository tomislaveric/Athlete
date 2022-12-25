//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import StravaApi

struct Home: ReducerProtocol {
    
    struct State: Equatable {
        var text: String = ""
    }
    
    enum Action: Equatable {
        case onAppearance
        case handleResponse(TaskResult<Athlete>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            return .task {
                await .handleResponse(TaskResult {
                    try await stravaApi.getProfile()
                })
            }
        case .handleResponse(.success(let result)):
            dump(result)
            state.text = result.username ?? "12"
            return .none
        case .handleResponse(.failure(let error)):
            print(error)
            return .none
        }
    }
    
    @Dependency(\.stravaApi) var stravaApi
}
