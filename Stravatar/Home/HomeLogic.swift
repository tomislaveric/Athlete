//
//  HomeLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import SwiftUI
import ComposableArchitecture
import HTTPRequest

struct Home: ReducerProtocol {
    
    struct State: Equatable {
        var text: String = ""       
    }
    
    enum Action: Equatable {
        case onAppearance
        case handleResponse(TaskResult<Activity>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            return .task {
                await .handleResponse(TaskResult { try await httpRequest.get(url: "https://www.boredapi.com/api/activity") })
            }
        case .handleResponse(.success(let result)):
            state.text = result.activity
            return .none
        case .handleResponse(.failure):
            return .none
        }
    }
    
    @Dependency(\.httpRequest) var httpRequest
}

struct Activity: Equatable, Decodable {
    let activity: String
}
