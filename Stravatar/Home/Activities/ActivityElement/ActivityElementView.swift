//
//  ActivityElementView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct ActivityElementView: View {
    let store: StoreOf<ActivityElementLogic>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading) {
                Text(viewStore.name ?? "Activity Name")
                HStack {
                    ForEach(viewStore.skills) {
                        Text("\($0.zoneType.rawValue): \($0.points)")
                    }
                }
            }
            .redacted(reason: viewStore.isLoading ? .placeholder : [])
            .onTapGesture {
                viewStore.send(.activitySelected)
            }
            .onAppear {
                viewStore.send(.viewAppeared)
            }
        }
    }
}
