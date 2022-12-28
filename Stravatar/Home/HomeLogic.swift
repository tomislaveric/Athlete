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
        case handleSuccessfulAuth(URL)
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
            state.text = result.username ?? ""
            return .none
        case .handleResponse(.failure(let error)):
            print(error)
            state.text = "Request error"
            return .none
        case .authorizeTapped:
            return EffectTask(value: Action.startAuthorization)
        case .startAuthorization:
            return .run { send in
                await authorize(send: send)
            }
            .receive(on: mainQueue)
            .eraseToEffect()
        case .handleSuccessfulAuth(let url):
            // TODO: Extract code and so on from URL
            return
                .none
                .receive(on: mainQueue)
                .eraseToEffect()
        }
    }
    
    @MainActor
    private func authorize(send: Send<Home.Action>) -> Void {
        oAuth.authorize { url, error in
            if let url = url {
                send(.handleSuccessfulAuth(url))
            }
        }
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.oAuth) var oAuth
    @Dependency(\.mainQueue) var mainQueue
}
