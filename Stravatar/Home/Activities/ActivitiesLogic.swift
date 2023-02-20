//
//  ActivityList.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SkillEngine

struct ActivitiesLogic: ReducerProtocol {
    
    struct State: Equatable {
        var activities: IdentifiedArrayOf<ActivityElementLogic.State> = []
        var isLoading = true
        let amountOfActivities: Int = 5
    }
    
    enum Action: Equatable {
        case activityElement(id: ActivityElementLogic.State.ID, action: ActivityElementLogic.Action)
        case fetchActivities
        case handleActivitiesResponse(TaskResult<[Activity]>)
        case setActivities([Activity]?)
    }
    
    @Dependency(\.stravaApi) var stravaApi
    @Dependency(\.skillEngine) var skillEngine
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchActivities:
                let amount = state.amountOfActivities
                return .task {
                    await .handleActivitiesResponse(TaskResult {
                        try await stravaApi.getActivities(amount)
                    })
                }
            case .handleActivitiesResponse(.success(let activities)):
                state.isLoading = false
                return .init(value: .setActivities(activities))
            case .handleActivitiesResponse(.failure(let error)):
                state.isLoading = false
                dump(error)
                return .none
            case .activityElement:
                return .none
            case .setActivities(let activities):
                guard let activities = activities?.prefix(state.amountOfActivities) else { return .none }
                state.activities = IdentifiedArrayOf(uniqueElements: activities.map {
                    let activity = $0
                    return ActivityElementLogic.State(
                        id: UUID().hashValue,
                        activity: activity,
                        skills: skillEngine.getSkillsFor(
                            heartRates: activity.heartRateTicks,
                            timeSample: activity.timeSample ?? 0)
                    )
                })
                return .none
            }
        }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
            ActivityElementLogic()
        }
    }
}
