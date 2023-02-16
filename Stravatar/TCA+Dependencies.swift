//
//  TCA+Dependencies.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import ComposableArchitecture
import StravaApi
import OAuth
import KeychainStorage
import SkillEngine

extension DependencyValues {
    
    var stravaApi: StravaUseCase {
        get { self[StravaUseCase.self] }
        set { self[StravaUseCase.self] = newValue }
    }
    
    private enum SkillEngineKey: DependencyKey {
        typealias Value = SkillEngine
        static let liveValue: SkillEngine = SkillEngineImpl()
    }
    
    var skillEngine: SkillEngine {
        get { self[SkillEngineKey.self] }
        set { self[SkillEngineKey.self] = newValue }
    }
}

public struct StravaUseCase {
    var registerTokenUpdate: () async throws -> Void
    var getProfile: () async throws -> DetailedAthlete
    var getActivities: () async throws -> [DetailedActivity]
    var getAthleteZones: () async throws -> Zones
    var getActivityHeartRateStream: (_ id: Int) async throws -> StreamSet
}

extension StravaUseCase: DependencyKey {
    static let config = StravaConfig(
        authorizeUrl: "https://www.strava.com/oauth/mobile/authorize",
        tokenUrl: "https://www.strava.com/oauth/token",
        clientId: "98743",
        redirectUri: "stravatar://authorization",
        callbackURLScheme: "stravatar",
        clientSecret: "e3edf448818cb884ad34d35b3750233e9d374152",
        scopes: [.activityRead, .activityWrite, .profileReadAll]
    )
    static let api: StravaApi = StravaApiImpl(config: config, oAuthClient: OAuthImpl(callbackURLScheme: config.callbackURLScheme))
    static let storage: KeychainStorage = KeychainStorageImpl()
    
    private static let storageName = Bundle.main.bundleIdentifier ?? "strava_api.oauth_token"
    public static let liveValue = Self(
        registerTokenUpdate: { try api.registerTokenUpdate(current: storage.read(name: storageName), callback: { newToken in try storage.save(name: storageName, object: newToken)}) },
        getProfile: { try await api.getDetailedAthlete() },
        getActivities: { try await api.getAthleteDetailedActivities() },
        getAthleteZones: { try await api.getAthleteZones() },
        getActivityHeartRateStream: { id in try await api.getActivityStreams(by: id, keys: [.heartrate, .time])}
    )
}
