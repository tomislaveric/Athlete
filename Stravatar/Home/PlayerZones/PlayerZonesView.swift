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
        Zone(range: 0..<1, type: .zone1),
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
                ForEach(viewStore.hrZones ?? placeholderZones) { zone in
                    ZoneView(type: zone.type, range: zone.range)
                }.redacted(reason: viewStore.isLoading ? .placeholder : [])
            }
        }
    }
    
    struct ZoneView: View {
        let type: ZoneType
        let range: Range<Int>
        
        var body: some View {
            if type == .zone5 {
                return Text("\(type.name): \(range.lowerBound) - ∞")
            } else {
                return Text("\(type.name): \(range.lowerBound) - \(range.upperBound)")
            }
        }
    }
}
