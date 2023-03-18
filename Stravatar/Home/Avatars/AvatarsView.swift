//
//  AvatarsView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 18.03.23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct AvatarsView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<AvatarsLogic>
    private let store: StoreOf<AvatarsLogic>
    
    init(store: StoreOf<AvatarsLogic>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEachStore(
                self.store.scope(state: \.avatars, action: AvatarsLogic.Action.avatar(id:action:))
            ) { store in
                AvatarView(store: store)
            }
            AvatarCreationView(store: self.store.scope(state: \.avatarCreation, action: AvatarsLogic.Action.avatarCreation))
        }.task {
            viewStore.send(.initialize)
        }
    }
}
