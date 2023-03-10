//
//  PlayerZonesView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import PlayerEngine

struct PlayerZonesView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<PlayerZonesLogic>
    
    init(store: StoreOf<PlayerZonesLogic>) {
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Text(String(.playerHRzonesTitle))
                    .bold()
                Text(String(.playerHRzonesDescription))
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(viewStore.hrZones) { zone in
                            Text("\(zone.type.name)")
                        }
                    }.redacted(reason: viewStore.isLoading ? .placeholder : [])
                    VStack(alignment: .leading) {
                        ForEach(viewStore.hrZones) { zone in
                            if zone.type == .zone5 {
                                Text("\(zone.range.lowerBound) - ∞")
                            } else {
                                Text("\(zone.range.lowerBound) - \(zone.range.upperBound)")
                            }
                        }
                    }.redacted(reason: viewStore.isLoading ? .placeholder : [])
                }
            }
        }
    }

}
