//
//  StravatarApp.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import SwiftUI
import ComposableArchitecture

@main
struct StravatarApp: App {
    let store = Store(
        initialState: HomeLogic.State(
            login: .init(),
            profile: .init(),
            avatars: .init()
        ),
        reducer: HomeLogic())
    var body: some Scene {
        WindowGroup {
            HomeView(store: self.store)
        }
    }
}
