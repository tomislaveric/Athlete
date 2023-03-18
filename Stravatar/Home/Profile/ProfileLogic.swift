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
        
        var connectionName: String? {
            profile?.activeConnection?.type.rawValue
        }
    }
    
    enum Action: Equatable {
        case skillZonesTapped
        case updateSkills
        case profileFetched(Profile)
        case stravaConnector(StravaConnectorLogic.Action)
        case heartRateZones(HeartRateZonesLogic.Action)
        case activityList(ActivitiesLogic.Action)
    }
    
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
            case .profileFetched(let profile):
                state.profile = profile
                state.isLoading = false
                return .none
            case .stravaConnector(let action):
                switch action {
                case .stravaConnected(let profile):
                    return .task { .profileFetched(profile) }
                case .zonesFetched(let zones):
                    state.profile?.hrZones = zones.filter { $0.type != .zone1 }
                    return .task { .heartRateZones(.setHRzones(zones)) }
                case .activitiesFetched(let activities):
                    state.profile?.activities = activities
                    return .task { .activityList(.setActivities(activities)) }
                default: return .none
                }
            case .skillZonesTapped, .updateSkills, .heartRateZones, .activityList:
                return .none
            }
        }
    }
}
