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
            profile: .init(playerName: .init()),
            skillsHud: .init(),
            avatar: .init(), playerZones: .init()
        ),
        reducer: HomeLogic())
    var body: some Scene {
        WindowGroup {
            HomeView(store: self.store)
        }
    }
}
