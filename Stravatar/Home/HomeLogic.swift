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
    
    private let bearerToken = ""
    
    struct State: Equatable {
        var text: String = ""
        let url = URL(string: "\(Endpoint.activity.rawValue)")!
    }
    
    enum Action: Equatable {
        case onAppearance
        case handleResponse(TaskResult<Activity>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .onAppearance:
            var urlRequest = URLRequest(url: state.url)
            urlRequest.addValue(bearerToken, forHTTPHeaderField: "Authorization")
            let request = urlRequest
            return .task {
                await .handleResponse(TaskResult {
                    try await httpRequest.get(request: request)
                })
            }
        case .handleResponse(.success(let result)):
            state.text = result.username
            return .none
        case .handleResponse(.failure(let result)):
            if let error = result as? HTTPRequestError {
                switch error {
                case .requestFailed(response: let response):
                    state.text = response.debugDescription
                }
            }
            return .none
        }
    }
    
    @Dependency(\.httpRequest) var httpRequest
}

struct Activity: Equatable, Decodable {
    let username: String
}

enum Endpoint: String {
    case activity = "https://www.strava.com/api/v3/athlete"
}
