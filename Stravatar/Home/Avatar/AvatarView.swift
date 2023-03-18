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
    @ObservedObject
    private var viewStore: ViewStoreOf<AvatarLogic>
    private let store: StoreOf<AvatarLogic>
    
    init(store: StoreOf<AvatarLogic>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                if let avatar = viewStore.avatar, let id = avatar.id, let name = avatar.name, let age = avatar.age {
                    avatarInfo(id: id, name: name, age: age)
                    Divider()
                    SkillsHudView(store: store.scope(state: \.skillsHud, action: AvatarLogic.Action.skillsHud))
                }
            }
        }
    }
    
    func avatarInfo(id: UUID, name: String, age: Int) -> some View {
        VStack(alignment: .leading) {
            Text(String(.avatarInfoTitle))
                .bold()
            Text("\(String(.avatarInfoName)): \(name)")
            Text("\(String(.avatarInfoAge)): \(age)")
        }
    }
}
