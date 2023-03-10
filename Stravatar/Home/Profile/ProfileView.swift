//
//  ProfileView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import SkillEngine

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
                Text(String(key: .profileTitle))
                    .bold()
                Divider()
                Text(viewStore.state.playerName ?? String(key: .placeholder))
                    .redacted(reason: viewStore.isLoading ? .placeholder : [])
                
            }
        }
    }
}
