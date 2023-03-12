//
//  StravaConnectorView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 11.03.23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct StravaConnectorView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<StravaConnectorLogic>
    init(store: StoreOf<StravaConnectorLogic>) {
        self.viewStore = ViewStore(store)
    }
    var body: some View {
        VStack {
            Text(String(.stravaProfileTitle))
                .bold()
            
            if !viewStore.isLoading {
                Button(String(.stravaConnectButtonTitle)) {
                    viewStore.send(.connect)
                }
            }
        }.task {
            viewStore.send(.initialized)
        }
    }
}
