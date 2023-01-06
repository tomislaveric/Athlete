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

extension DependencyValues {
    private enum StravaApiKey: DependencyKey {
        typealias Value = StravaApi
        static let config = StravaConfig(
            scope: "activity:read",
        )
        static let liveValue: StravaApi = StravaApiImpl(config: config, oAuthClient: OAuthImpl(callbackURLScheme: config.callbackURLScheme))
    }
    
    var stravaApi: StravaApi {
        get { self[StravaApiKey.self] }
        set { self[StravaApiKey.self] = newValue }
    }
    
    private enum KeychainStorageKey: DependencyKey {
        typealias Value = KeychainStorage
        static let liveValue: KeychainStorage = KeychainStorageImpl()
    }
    
    var keychainStorage: KeychainStorage {
        get { self[KeychainStorageKey.self] }
        set { self[KeychainStorageKey.self] = newValue }
    }
}
