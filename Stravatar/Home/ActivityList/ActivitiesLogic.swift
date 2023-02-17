//
//  ActivityList.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation

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
        case handleActivityHeartRateResponse(TaskResult<ActivityHeartRate>)
    }
    
    @Dependency(\.stravaApi) var stravaApi
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchActivities:
                return .task {
                    await .handleActivitiesResponse(TaskResult {
                        try await stravaApi.getActivities()
                    })
                }
            case .handleActivitiesResponse(.success(let response)):
                state.isLoading = false
                let activities = response.map { Activity(id: $0.id, name: $0.name) }
                return .init(value: .setActivities(activities))
            case .handleActivitiesResponse(.failure(let error)):
                state.isLoading = false
                dump(error)
                return .none
            case .activityElement(id: let id, action: let action):
                switch action {
                case .activitySelected:
                    return .task {
                        await .handleActivityHeartRateResponse(TaskResult {
                            try await stravaApi.getActivityHeartRateStream(id)
                        })
                    }
                }
            case .handleActivityHeartRateResponse(.success(let response)):
                return .none
            case .handleActivityHeartRateResponse(.failure):
                return .none
            case .setActivities(let activities):
                guard let activities = activities?.prefix(state.amountOfActivities) else { return .none }
                state.activities = IdentifiedArrayOf(uniqueElements: activities.map { ActivityElementLogic.State(id: $0.id ?? UUID().hashValue, name: $0.name) })
                return .none
            }
        }.forEach(\.activities, action: /Action.activityElement(id:action:)) {
            ActivityElementLogic()
        }
    }
}
