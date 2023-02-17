//
//  HomeScreen.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import SwiftUI
import ComposableArchitecture

struct HomeScreen: View {
    let store: StoreOf<Home>

    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(spacing: 0) {
                HStack(alignment: .top, spacing: 0) {
                    ActivitiesView(store: store.scope(state: \.activityList, action: Home.Action.activityList))
                    Spacer()
                        .frame(maxWidth: .infinity)
                    ProfileView(store: store.scope(state: \.profile, action: Home.Action.profile))
                }
                
                Text(viewStore.state.text)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewStore.send(.onAppearance)
            }
        }
    }
}
