//
//  PlayerHubView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct PlayerHubView: View {
    let store: StoreOf<PlayerHub>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                Text("Profile")
                    .bold()
                Divider()
                if let name = viewStore.playerName {
                    Text(name)
                }
                
                if let zones = viewStore.hrZones {
                    Text("zone 1: \(zones[0].lowerBound) - \(zones[0].upperBound)")
                    Text("zone 2: \(zones[1].lowerBound) - \(zones[1].upperBound)")
                    Text("zone 3: \(zones[2].lowerBound) - \(zones[2].upperBound)")
                    Text("zone 4: \(zones[3].lowerBound) - \(zones[3].upperBound)")
                    Text("zone 5: \(zones[4].lowerBound) - ∞")
                }
            }
        }
    }
}
