//
//  HomeScreen.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import SwiftUI
import ComposableArchitecture

struct HomeView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<HomeLogic>
    private let store: StoreOf<HomeLogic>
    
    init(store: StoreOf<HomeLogic>) {
        self.viewStore = ViewStore(store)
        self.store = store
    }
    
    var body: some View {
       
        HStack{
            VStack(alignment: .leading) {
                ProfileView(store: store.scope(state: \.profile, action: HomeLogic.Action.profile))
                Spacer()
            }
            
            VStack {
                HStack(alignment: .top) {
                    AvatarsView(store: store.scope(state: \.avatars, action: HomeLogic.Action.avatars))
                }
                Spacer()
            }
            
        }
        .onAppear {
            viewStore.send(.onAppearance)
        }
    }
}
