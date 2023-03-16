//
//  PlayerZonesView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import AvatarService

struct PlayerZonesView: View {
    @ObservedObject
    private var viewStore: ViewStoreOf<PlayerZonesLogic>
    
    init(store: StoreOf<PlayerZonesLogic>) {
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
