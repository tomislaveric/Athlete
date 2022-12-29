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
        
        static let liveValue: StravaApi = StravaApiImpl()
    }
    
    var stravaApi: StravaApi {
        get { self[StravaApiKey.self] }
        set { self[StravaApiKey.self] = newValue }
    }
    
    private enum OAuthKey: DependencyKey {
        typealias Value = OAuth
        static let config = OAuthConfig(
            authorizeUrl: "",
            tokenUrl: "",
            clientId: "",
            redirectUri: "",
            callbackURLScheme: "",
            clientSecret: ""
        )
        static let liveValue: OAuth = OAuthImpl(config: config)
    }
    
    var oAuth: OAuth {
        get { self[OAuthKey.self] }
        set { self[OAuthKey.self] = newValue }
    }
    
    private enum MainQueueKey: DependencyKey {
        typealias Value = AnySchedulerOf<DispatchQueue>
        
        static let liveValue: AnySchedulerOf<DispatchQueue> = DispatchQueue.main.eraseToAnyScheduler()
    }
    
    var mainQueue: AnySchedulerOf<DispatchQueue> {
        get { self[MainQueueKey.self] }
        set { self[MainQueueKey.self] = newValue }
    }
    
    
}
