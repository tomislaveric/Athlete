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
                Text(String(.profileTitle))
                    .bold()
                Divider()
                Text(viewStore.state.playerName ?? String(.placeholder))
                    .redacted(reason: viewStore.isLoading ? .placeholder : [])
                
            }
        }
    }
}
