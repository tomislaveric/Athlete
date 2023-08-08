//
//  LoginView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 07.08.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct LoginView: View {
    @FocusState var passwordInFocus: Bool
    
    @ObservedObject
    private var viewStore: ViewStoreOf<LoginLogic>
    
    init(store: StoreOf<LoginLogic>) {
        viewStore = ViewStore(store)
    }
    
    var body: some View {
        VStack {
            Text("Welcome, please enter your E-Mail Address")
            TextField("some.nice@address.com", text: viewStore.binding(get: \.username, send: { .usernameEntered($0) } ))
                .onSubmit {
                    passwordInFocus = true
                    viewStore.send(.onUserSubmit)
                }
                .disableAutocorrection(true)
            
            if viewStore.userSubmitted {
                SecureField("Password", text: viewStore.binding(get: \.password, send: { .passwordEntered($0) } ))
                    .onSubmit {
                        viewStore.send(.onSubmit)
                    }
                    .disableAutocorrection(true)
                    .focused($passwordInFocus)
                
            }
            if viewStore.userSubmitted {
                Button(viewStore.buttonTitle) {
                    viewStore.send(.onSubmit)
                }
            }
        }.textFieldStyle(.roundedBorder)
    }
}
