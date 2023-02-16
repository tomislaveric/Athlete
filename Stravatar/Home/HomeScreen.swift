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
                    ActivityListView(store: store.scope(state: \.activityList, action: Home.Action.activityList))
                    Spacer()
                        .frame(maxWidth: .infinity)
                    PlayerHubView(store: store.scope(state: \.playerHub, action: Home.Action.playerHub))
                }
                
                Text(viewStore.state.text)

                Button("Get Activity HeartStream") {
                    viewStore.send(.getActivityHeartRateStreamTapped)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .onAppear {
                viewStore.send(.onAppearance)
            }
        }
    } 
}
