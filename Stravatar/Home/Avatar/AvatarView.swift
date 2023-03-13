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
                if let player = viewStore.player, let name = player.name, let age = player.age {
                    avatarInfo(name: name, age: age)
                    Divider()
                    SkillsHudView(store: store.scope(state: \.skillsHud, action: AvatarLogic.Action.skillsHud))
                } else {
                    avatarCreationView
                }
            }
        }.task {
            viewStore.send(.initialize)
        }
    }
    
    func avatarInfo(name: String, age: Int) -> some View {
        VStack(alignment: .leading) {
            Text(String(.avatarInfoTitle))
                .bold()
           
            if viewStore.inEditMode {
                nameField(
                    buttonTitle: String(.avatarInfoUpdateNameButton),
                    action: { viewStore.send(.updateNameTapped) })
            } else {
                HStack {
                    Text("\(String(.avatarInfoName)): \(name)")
                    Button(String(.edit)) { viewStore.send(.editName) }
                }
            }
            
            Text("\(String(.avatarInfoAge)): \(age)")
        }
    }
    
    var avatarCreationView: some View {
        VStack(alignment: .leading) {
            Text(String(.avatarCreationNameInput))
            nameField(
                buttonTitle: String(.avatarCreationButtonTitle),
                action: { viewStore.send(.saveNameTapped) })
        }
    }
    
    func nameField(buttonTitle: String, action: @escaping () -> Void) -> some View {
        HStack {
            TextField(String(.avatarCreationNameInputPlaceholder),
                      text: viewStore.binding(
                        get: { $0.enteredName },
                        send: AvatarLogic.Action.nameEntered)
            )
            Button(buttonTitle, action: action)
            .disabled(!viewStore.isButtonActive)
        }
    }
}
