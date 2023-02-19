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
    let store: StoreOf<PlayerZonesLogic>
    
    private let placeholderZones = [
        Zone(range: 0..<1, type: .zone1),
        Zone(range: 0..<1, type: .zone2),
        Zone(range: 0..<1, type: .zone3),
        Zone(range: 0..<1, type: .zone4),
        Zone(range: 0..<1, type: .zone5)
    ]
    
    var body: some View {
        WithViewStore(store) { viewStore in
            Group {
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
                return Text("\(type.rawValue): \(range.lowerBound) - ∞")
            } else {
                return Text("\(type.rawValue): \(range.lowerBound) - \(range.upperBound)")
            }
        }
    }
}
