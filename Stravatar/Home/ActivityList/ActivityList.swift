//
//  ActivityList.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation

struct ActivityList: ReducerProtocol {
    
    struct State: Equatable {
        var activities: IdentifiedArrayOf<ActivityElement.State> = []
    }
    
    enum Action: Equatable {
        case activityElement(id: ActivityElement.State.ID, action: ActivityElement.Action)
        case setActivities([Activity]?)
    }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setActivities(let activities):
                guard let activities = activities?.prefix(5) else { return .none }
                state.activities = IdentifiedArrayOf(uniqueElements: activities.map { ActivityElement.State(id: $0.id ?? UUID().hashValue, name: $0.name) })
                return .none
            }
        }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
            ActivityElement()
        }
    }
}
