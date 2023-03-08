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
    @ObservedObject
    private var viewStore: ViewStoreOf<SkillsHudLogic>
    
    init(store: StoreOf<SkillsHudLogic>) {
        self.viewStore = ViewStore(store)
    }
    
    var body: some View {
        GroupBox {
            VStack(alignment: .leading) {
                Text("Skills")
                    .bold()
                Divider()
                ForEach(viewStore.playerSkills) { skill in
                    HStack {
                        Text("\(skill.name)")
                        Text(String(format: "%.0f", skill.points))
                    }
                }
            }
            
        }
    }
}
