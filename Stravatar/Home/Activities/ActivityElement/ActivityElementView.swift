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
                Text(viewStore.activity.name ?? "Activity Name")
                HStack {
                    ForEach(viewStore.skills, id: \.zoneType) {
                        Text("\($0.zoneType.rawValue): \($0.points)")
                    }
                }
            }
            .onTapGesture {
                viewStore.send(.activitySelected)
            }
        }
    }
}
