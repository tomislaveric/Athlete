//
//  PlayerZonesView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import SkillEngine

struct PlayerZonesView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<PlayerZonesLogic>
    
    init(store: StoreOf<PlayerZonesLogic>) {
        self.viewStore = ViewStore(store)
    }
    
    private let placeholderZones = [
        Zone(range: 0..<1, type: .zone2),
        Zone(range: 0..<1, type: .zone3),
        Zone(range: 0..<1, type: .zone4),
        Zone(range: 0..<1, type: .zone5)
    ]
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Text(String(key: .playerHRzonesTitle))
                    .bold()
                Text(String(key: .playerHRzonesDescription))
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(viewStore.hrZones ?? placeholderZones) { zone in
                            Text("\(zone.type.name)")
                        }
                    }.redacted(reason: viewStore.isLoading ? .placeholder : [])
                    VStack(alignment: .leading) {
                        ForEach(viewStore.hrZones ?? placeholderZones) { zone in
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
