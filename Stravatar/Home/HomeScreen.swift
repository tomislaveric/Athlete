//
//  HomeScreen.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import SwiftUI
import ComposableArchitecture

struct HomeScreen: View {
    let store: Store<Home.State, Home.Action>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                Text(viewStore.state.text)
                Button("Get Profile") {
                    viewStore.send(.getProfileTapped)
                }
                Button("Get Activities") {
                    viewStore.send(.getActivitiesTapped)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewStore.send(.onAppearance)
            }
        }
    } 
}
