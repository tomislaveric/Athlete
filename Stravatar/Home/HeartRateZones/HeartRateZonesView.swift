//
//  PlayerZonesView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI

struct HeartRateZonesView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<HeartRateZonesLogic>
    
    init(store: StoreOf<HeartRateZonesLogic>) {
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        GroupBox {
            if !viewStore.isLoading {
                VStack(alignment: .leading) {
                    Text(String(.playerHRzonesTitle))
                        .bold()
                    Text(String(.playerHRzonesDescription))
                    HStack {
                        VStack(alignment: .leading) {
                            ForEach(viewStore.hrZones) { zone in
                                Text("\(zone.type.name)")
                            }
                        }
                        VStack(alignment: .leading) {
                            ForEach(viewStore.hrZones) { zone in
                                if zone.type == .zone5 {
                                    Text("\(zone.range.lowerBound) - ∞")
                                } else {
                                    Text("\(zone.range.lowerBound) - \(zone.range.upperBound)")
                                }
                            }
                        }
                    }
                }
            }
        }
    }

}
