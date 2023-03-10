//
//  ActivityListView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ActivitiesView: View {
    private let store: StoreOf<ActivitiesLogic>
    private var viewStore: ViewStoreOf<ActivitiesLogic>
    
    init(store: StoreOf<ActivitiesLogic>) {
        self.store = store
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        if !viewStore.isLoading {
            GroupBox {
                VStack(alignment: .leading) {
                    Text(String(.activitiesTitle)).bold()
                    ForEachStore(
                        self.store.scope(state: \.activities, action: ActivitiesLogic.Action.activityElement(id:action:))
                    ) { todoStore in
                        ActivityElementView(store: todoStore)
                    }
                }
            }
        }
    }
}
