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
            avatar: .init(
                skillsHud: .init()
            ),
            playerZones: .init()
        ),
        reducer: HomeLogic())
    var body: some Scene {
        WindowGroup {
            HomeView(store: self.store)
        }
    }
}
