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
    let store: StoreOf<ActivityElement>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            if let name = viewStore.name {
                Text(name)
            }
        }
    }
}
