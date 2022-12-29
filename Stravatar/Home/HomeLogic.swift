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
        var authorizationInProgress = false
        var authorizedURL: URL? = nil
    }
    
    enum Action: Equatable {
        case onAppearance
        case handleResponse(TaskResult<Athlete>)
        case authorizeTapped
        case startAuthorization
        case handleAuthResult(TaskResult<String?>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            return .none
        case .handleResponse(.success(let result)):
            dump(result)
            state.text = result.username ?? ""
            return .none
        case .handleResponse(.failure(let error)):
            print(error)
            state.text = "Request error"
            return .none
        case .authorizeTapped:
            return EffectTask(value: Action.startAuthorization)
        case .startAuthorization:
            return .task {
                await .handleAuthResult(TaskResult {
                    try await oAuth.authorize()
                })
            }
        case .handleAuthResult(.success(let token)):
            return .task {
                await .handleResponse(TaskResult {
                    try await stravaApi.getProfile(token: token)
                })
            }
        case .handleAuthResult(.failure(let error)):
            print(error)
            return .none
        }
    }
    
    @MainActor
    private func authorize() async throws -> String? {
        return try await oAuth.authorize()
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.oAuth) var oAuth
    @Dependency(\.mainQueue) var mainQueue
}
