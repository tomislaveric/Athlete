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

extension DependencyValues {
    private enum StravaApiKey: DependencyKey {
        typealias Value = StravaApi
        static let config = OAuthConfig(
            scope: "activity:read",
        )
        static let liveValue: StravaApi = StravaApiImpl(oAuthClient: OAuthImpl(config: config))
    }
    
    var stravaApi: StravaApi {
        get { self[StravaApiKey.self] }
        set { self[StravaApiKey.self] = newValue }
    }
}
