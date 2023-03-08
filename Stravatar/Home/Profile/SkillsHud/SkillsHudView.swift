//
//  SkillsHudView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 27.02.23.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct SkillsHudView: View {
    let store: StoreOf<SkillsHudLogic>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            VStack {
                ForEach(viewStore.playerSkills) {
                    Text("\($0.zoneType.rawValue) - \($0.points)")
                    ProgressView(value: $0.points, total: 1000000)
                }
            }
        }
    }
}
