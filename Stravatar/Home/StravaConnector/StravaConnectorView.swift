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
    private let viewStore: ViewStoreOf<StravaConnectorLogic>
    init(store: StoreOf<StravaConnectorLogic>) {
        self.viewStore = ViewStore(store)
    }
    var body: some View {
        VStack {
            Button(viewStore.name) {
                viewStore.send(.connectTapped)
            }
        }
    }
}
