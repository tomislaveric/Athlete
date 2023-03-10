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
                if let player = viewStore.player {
                    avatarInfo(name: player.name, age: player.age)
                    Divider()
                    SkillsHudView(store: store.scope(state: \.skillsHud, action: AvatarLogic.Action.skillsHud))
                } else {
                    avatarCreationView
                }
            }
        }
    }
    
    func avatarInfo(name: String, age: Int) -> some View {
        VStack(alignment: .leading) {
            Text(String(.avatarInfoTitle))
                .bold()
            Text("\(String(.avatarInfoName)): \(name)")
            Text("\(String(.avatarInfoAge)): \(age)")
        }
    }
    
    var avatarCreationView: some View {
        VStack(alignment: .leading) {
            Text(String(.avatarCreationNameInput))
            TextField(String(.avatarCreationNameInputPlaceholder),
                      text: viewStore.binding(
                        get: { $0.enteredName },
                        send: AvatarLogic.Action.nameEntered)
            )
            Button(String(.avatarCreationButtonTitle), action: {
                viewStore.send(.saveNameTapped)
            })
        }
    }
}
