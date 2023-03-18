//
//  ProfileView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ProfileView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<ProfileLogic>
    private let store: StoreOf<ProfileLogic>
    
    init(store: StoreOf<ProfileLogic>) {
        self.viewStore = ViewStore(store)
        self.store = store
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                
                StravaConnectorView(store: store.scope(state: \.stravaConnector, action: ProfileLogic.Action.stravaConnector))
                
                Text(viewStore.connectionName ?? String(.placeholder))
                    .redacted(reason: viewStore.isLoading ? .placeholder : [])
                
                HeartRateZonesView(store: store.scope(state: \.heartRateZones, action: ProfileLogic.Action.heartRateZones))
                ActivitiesView(store: store.scope(state: \.activityList, action: ProfileLogic.Action.activityList))
            }
        }
    }
}
