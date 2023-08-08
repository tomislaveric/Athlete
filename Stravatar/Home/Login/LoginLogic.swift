//
//  LoginLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 07.08.23.
//

import ComposableArchitecture
import Foundation

struct LoginLogic: ReducerProtocol {
    
    struct State: Equatable {
        var username: String = ""
        var password: String = ""
        var userExists: Bool = false
        var userSubmitted: Bool = false
        
        var buttonTitle: String {
            userExists ? "Login" : "Create Account"
        }
    }
    
    enum Action: Equatable {
        case usernameEntered(String)
        case passwordEntered(String)
        case onUserSubmit
        case onSubmit
        case login
        case register
        case userLoggedIn
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .usernameEntered(let value):
                state.username = value
                return .none
            case .passwordEntered(let value):
                state.password = value
                return .none
            case .onUserSubmit:
                //TODO: fetch value from backend
                state.userExists = true
                state.userSubmitted = true
                return .none
            case .onSubmit:
                if state.userExists {
                    return .task { .login }
                } else {
                    return .task { .register }
                }
            case .login, .register:
                //TODO: trigger login
                return .task { .userLoggedIn }
            case .userLoggedIn:
                //Handled in Parent
                return .none
            }
        }
    }
}
