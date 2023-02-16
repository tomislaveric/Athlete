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
        initialState: Home.State(playerHub: .init(playerName: nil), activityList: .init()),
        reducer: Home())
    var body: some Scene {
        WindowGroup {
            HomeScreen(store: self.store)
        }
    }
}
