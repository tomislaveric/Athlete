//
//  ActivityList.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import PlayerEngine

struct ActivitiesLogic: ReducerProtocol {
    
    struct State: Equatable {
        var activities: IdentifiedArrayOf<ActivityElementLogic.State> = []
        var isLoading = true
    }
    
    enum Action: Equatable {
        case activityElement(id: ActivityElementLogic.State.ID, action: ActivityElementLogic.Action)
        case setActivities([Activity]?)
        case skillsEarned
        case handleUpdateResponse(TaskResult<Player>)
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.playerEngine) var playerEngine
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .activityElement(_, let action):
                switch action {
                case .selected(let activity):
                    let skills = playerEngine.getSkillsFor(
                        heartRates: activity.heartRateTicks,
                        timeSample: activity.timeSample ?? 0)
                    return .task { await .handleUpdateResponse(TaskResult {
                        try playerEngine.update(skills: skills)
                    })}
                default: return .none
                }
            case .setActivities(let activities):
                guard let activities else { return .none }
                state.activities = IdentifiedArrayOf(uniqueElements: activities.map {
                    let activity = $0
                    return ActivityElementLogic.State(activity: activity)
                })
                return .none
            case .skillsEarned:
                return .none
            case .handleUpdateResponse(.success(_)):
                return .task { .skillsEarned }
            case .handleUpdateResponse:
                return .none
            }
        }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
            ActivityElementLogic()
        }
    }
}
