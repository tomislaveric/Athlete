//
//  AvatarCreationView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 18.03.23.
//

import Foundation
import ComposableArchitecture
import SwiftUI

struct AvatarCreationView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<AvatarCreationLogic>
    private let store: StoreOf<AvatarCreationLogic>

    init(store: StoreOf<AvatarCreationLogic>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }

    var body: some View {
        avatarCreationView
    }
    
    var avatarCreationView: some View {
        VStack(alignment: .leading) {
            Text(String(.avatarCreationNameInput))
            nameField(
                buttonTitle: String(.avatarCreationButtonTitle),
                action: { viewStore.send(.saveTapped) })
        }
    }
    
    func nameField(buttonTitle: String, action: @escaping () -> Void) -> some View {
        HStack {
            TextField(String(.avatarCreationNameInputPlaceholder),
                      text: viewStore.binding(
                        get: { $0.enteredName },
                        send: AvatarCreationLogic.Action.nameEntered)
            )
            Button(buttonTitle, action: action)
            .disabled(!viewStore.isButtonActive)
        }
    }
}

