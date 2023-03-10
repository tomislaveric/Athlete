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
                Text(String(key: .skillsHudTitle))
                    .bold()
                Divider()
                HStack {
                    VStack(alignment: .leading) {
                        ForEach(viewStore.playerSkills) { skill in
                            Text("\(skill.zoneType.name)")
                        }
                    }
                    VStack(alignment: .leading) {
                        ForEach(viewStore.playerSkills) { skill in
                            Text(String(format: "%.0f", skill.points))
                        }
                        
                    }
                }
            }
        }
    }
}
