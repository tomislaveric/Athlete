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
        VStack(alignment: .leading) {
            Text(String(.skillsHudTitle))
                .bold()
            HStack {
                VStack(alignment: .leading) {
                    ForEach(viewStore.avatarSkills) { skill in
                        Text("\(skill.zoneType.name)")
                    }
                }
                VStack(alignment: .leading) {
                    ForEach(viewStore.avatarSkills) { skill in
                        Text(String(format: "%.0f", skill.points))
                    }
                    
                }
            }
        }
    }
}
