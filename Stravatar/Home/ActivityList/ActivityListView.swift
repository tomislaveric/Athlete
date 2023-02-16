//
//  ActivityListView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ActivityListView: View {
    let store: StoreOf<ActivityList>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text("Latest Activities")
                    .bold()
                Divider()
                ForEachStore(
                    self.store.scope(state: \.activities, action: ActivityList.Action.activityElement(id:action:))
                ) { todoStore in
                  ActivityElementView(store: todoStore)
                }
            }
        }
    }
}
