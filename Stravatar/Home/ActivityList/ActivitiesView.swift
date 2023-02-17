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
    let store: StoreOf<ActivitiesLogic>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            GroupBox {
                VStack(alignment: .leading) {
                    Text("Latest Activities").bold()
                    Divider()
                    
                    if viewStore.state.activities.isEmpty {
                        ForEach(0..<viewStore.state.amountOfActivities, id: \.self) { _ in
                            Text("Placeholder")
                                .redacted(reason: viewStore.isLoading ? .placeholder : [])
                        }
                    } else {
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
}
