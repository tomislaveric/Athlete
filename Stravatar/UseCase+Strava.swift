//
//  UseCase+Strava.swift
//  Stravatar
//
//  Created by Tomislav Eric on 10.03.23.
//

import Foundation
import ComposableArchitecture
import StravaApi
import KeychainStorage
import OAuth
import SharedModels

public struct StravaUseCase {
    var isTokenAvailable: () throws -> Bool
    var registerTokenUpdate: () async throws -> Void
    var getProfile: () async throws -> Profile
    var getActivities: (_ amount: Int) async throws -> [Activity]
    var getAthleteZones: () async throws -> [Zone]
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
        isTokenAvailable: {
            let token: Token? = try storage.read(name: storageName)
            return token != nil
        },
        registerTokenUpdate: {
            try api.registerTokenUpdate(
                current: storage.read(name: storageName),
                callback: { newToken in
                    try storage.save(name: storageName, object: newToken)
                })
        },
        getProfile: {
            let athlete = try await api.getDetailedAthlete()
            guard let id = athlete.id else { throw StravaError.idParsingFailed }
            return Profile(name: athlete.firstname, creationDate: nil)
        },
        getActivities: { amount in
            let activities = try await api.getAthleteDetailedActivities(perPage: amount)
            
            var mappedActivities: [Activity] = []
            for activity in activities {
                let stream = try await api.getActivityStreams(by: activity.id, keys: [.heartrate])
                let mappedActivity = Activity(
                    id: activity.id,
                    name: activity.name,
                    duration: activity.elapsed_time ?? 0,
                    heartRateTicks: stream.heartrate?.data?.compactMap { Int($0) } ?? [],
                    sportsType: map(stravaSportType: activity.sport_type?.rawValue)
                )
                
                if !mappedActivities.contains(mappedActivity) {
                    mappedActivities.append(mappedActivity)
                }
            }
            return mappedActivities
        },
        getAthleteZones: {
            let zone = try await api.getAthleteZones()
            guard let zones = zone.heart_rate?.zones, let ranges = try mapHeartRateZones(zoneRanges: zones) else {
                throw StravaError.couldNotMap
            }
            return ranges
        }
    )
    
    private static func map(stravaSportType: String?) -> SharedModels.SportType {
        switch stravaSportType {
        case "Ride": return .bike
        case "Run": return .run
        default: return .unknown
        }
    }
    
    private static func mapHeartRateZones(zoneRanges: [ZoneRange]) throws -> [Zone]? {
        return try zoneRanges.enumerated().compactMap { index, element in
            if let min = element.min, let max = element.max {
                return Zone(range: min..<(max < min ? Int.max : max), type: try getZoneType(by: index))
            }
            return nil
        }
        
        func getZoneType(by index: Int) throws -> SharedModels.ZoneType {
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
    case idParsingFailed
}
