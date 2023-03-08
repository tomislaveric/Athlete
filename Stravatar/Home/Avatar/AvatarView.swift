//
//  AvatarView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 08.03.23.
//
import ComposableArchitecture
import SwiftUI
import Foundation
struct AvatarView: View {
    private let store: StoreOf<AvatarLogic>
    private var viewStore: ViewStoreOf<AvatarLogic>
    
    init(store: StoreOf<AvatarLogic>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        VStack {
            Text("AVATAR")
        }.frame(maxWidth: .infinity)
        
    }
}
