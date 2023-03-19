//
//  ProfileLogic.swift
//  Stravatar
//
//  Created by Tomislav Eric on 16.02.23.
//

import ComposableArchitecture
import Foundation
import SharedModels

struct ProfileLogic: ReducerProtocol {
    struct State: Equatable {
        var stravaConnector = StravaConnectorLogic.State()
        var heartRateZones = HeartRateZonesLogic.State()
        var activityList = ActivitiesLogic.State()
        var profile: Profile?
        var isLoading: Bool = true
    }
    
    enum Action: Equatable {
        case skillZonesTapped
        case updateSkills
        case connectedProfileFetched(Profile)
        case createProfile(Profile)
        case handleProfileResponse(TaskResult<Profile>)
        case stravaConnector(StravaConnectorLogic.Action)
        case heartRateZones(HeartRateZonesLogic.Action)
        case activityList(ActivitiesLogic.Action)
    }
    
    @Dependency(\.profileService) var profileService
    
    var body: some ReducerProtocol<State, Action> {
        Scope(state: \.stravaConnector, action: /Action.stravaConnector) {
            StravaConnectorLogic()
        }
        Scope(state: \.heartRateZones, action: /Action.heartRateZones) {
            HeartRateZonesLogic()
        }
        Scope(state: \.activityList, action: /Action.activityList) {
            ActivitiesLogic()
        }
        Reduce { state, action in
            switch action {
            case .connectedProfileFetched(let profile):
                state.isLoading = false
                return .task { .createProfile(profile) }
            case .createProfile(let profile):
                return .task {
                    await .handleProfileResponse(TaskResult {
                        try await profileService.create(profile: profile)
                    })
                }
            case .handleProfileResponse(.success(let profile)):
                state.profile = profile
                return .none
            case .stravaConnector(let action):
                switch action {
                case .stravaConnected(let profile):
                    return .task { .connectedProfileFetched(profile) }
                case .zonesFetched(let zones):
                    return .task { .heartRateZones(.setHRzones(zones)) }
                case .activitiesFetched(let activities):
                    return .task { .activityList(.setActivities(activities)) }
                default: return .none
                }
            case .skillZonesTapped, .updateSkills, .heartRateZones, .activityList, .handleProfileResponse:
                return .none
            }
        }
    }
}
