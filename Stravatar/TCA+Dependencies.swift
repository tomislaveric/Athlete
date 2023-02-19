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
    var getProfile: () async throws -> Profile
    var getActivities: () async throws -> [Activity]
    var getAthleteZones: () async throws -> [Zone]
    var getActivityHeartRateStream: (_ id: Int) async throws -> ActivityHeartRate
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
        registerTokenUpdate: {
            try api.registerTokenUpdate(
                current: storage.read(name: storageName),
                callback: { newToken in
                    try storage.save(name: storageName, object: newToken)
                })
        },
        getProfile: {
            let athlete = try await api.getDetailedAthlete()
            return Profile(name: athlete.firstname)
        },
        getActivities: {
            let activities = try await api.getAthleteDetailedActivities()
            return activities.map { Activity(id: $0.id, name: $0.name, duration: $0.elapsed_time) }
        },
        getAthleteZones: {
            let zone = try await api.getAthleteZones()
            guard let zones = zone.heart_rate?.zones, let ranges = try mapHeartRateZones(zoneRanges: zones) else {
                throw StravaError.couldNotMap
            }
            return ranges
        },
        getActivityHeartRateStream: { id in
            guard let data = try await api.getActivityStreams(by: id, keys: [.heartrate, .time]).heartrate?.data else {
                throw StravaError.couldNotMap
            }
            return ActivityHeartRate(data: data.map { Int($0) })
        }
    )
    
    static func mapHeartRateZones(zoneRanges: [ZoneRange]) throws -> [Zone]? {
        return try zoneRanges.enumerated().compactMap { index, element in
            if let min = element.min, let max = element.max {
                return Zone(range: min..<(max < min ? Int.max : max), type: try getZoneType(by: index))
            }
            return nil
        }
        
        func getZoneType(by index: Int) throws -> SkillEngine.SEZoneType {
            switch index {
            case 0: return .zone1
            case 1: return .zone2
            case 2: return .zone3
            case 3: return .zone4
            case 4: return .zone5
            default: throw StravaError.zoneOutOfRange
            }
        }
    }
}

enum StravaError: Error {
    case couldNotMap
    case zoneOutOfRange
}
