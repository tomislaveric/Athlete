//
//  ProfileView.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SwiftUI
import SkillEngine

struct ProfileView: View {
    let store: StoreOf<ProfileLogic>
    
    var body: some View {
        WithViewStore(store) { viewStore in
            GroupBox {
                VStack(alignment: .leading) {
                    Group {
                        Text("Profile")
                            .bold()
                        Divider()
                        Text(viewStore.state.playerName ?? "Placeholder")
                            .redacted(reason: viewStore.isLoading ? .placeholder : [])
                    }
                    
                    PlayerZonesView(
                        store: store.scope(state: \.playerZones, action: ProfileLogic.Action.playerZones)
                    )
                    Divider()
                    ActivitiesView(
                        store: store.scope(state: \.activityList, action: ProfileLogic.Action.activityList)
                    )
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
   static var previews: some View {
       ProfileView(store: Store(
        initialState: ProfileLogic.State(
            playerName: "Tomislav Eric",
            playerZones: .init(hrZones: [Zone(range: 0..<120, type: .zone1),
                                         Zone(range: 120..<150, type: .zone2),
                                         Zone(range: 150..<170, type: .zone3),
                                         Zone(range: 170..<190, type: .zone4),
                                         Zone(range: 190..<200, type: .zone5)],
                               isLoading: false)
        ),
        reducer: ProfileLogic()))
           .previewDevice(PreviewDevice(rawValue: "Mac"))
   }
}
