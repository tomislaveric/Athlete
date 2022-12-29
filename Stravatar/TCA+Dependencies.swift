//
//  TCA+Dependencies.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import ComposableArchitecture
import StravaApi

extension DependencyValues {
    private enum StravaApiKey: DependencyKey {
        typealias Value = StravaApi
        static let config = StravaConfig(
            authorizeUrl: "",
            tokenUrl: "",
            clientId: "",
            redirectUri: "",
            callbackURLScheme: "",
            clientSecret: "",
            scope: [""]
        )
        static let liveValue: StravaApi = StravaApiImpl(config: config)
    }
    
    var stravaApi: StravaApi {
        get { self[StravaApiKey.self] }
        set { self[StravaApiKey.self] = newValue }
    }
}
