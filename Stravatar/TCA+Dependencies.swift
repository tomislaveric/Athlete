//
//  TCA+Dependencies.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    static var baseURL = "http://localhost:8080"
    
    var stravaApi: StravaUseCase {
        get { self[StravaUseCase.self] }
        set { self[StravaUseCase.self] = newValue }
    }
    
    private enum AvatarServiceKey: DependencyKey {
        typealias Value = AvatarService
        static let liveValue: AvatarService = AvatarServiceImpl(baseURL: baseURL)
    }
    
    var avatarService: AvatarService {
        get { self[AvatarServiceKey.self] }
        set { self[AvatarServiceKey.self] = newValue }
    }
    
    private enum ProfileServiceKey: DependencyKey {
        typealias Value = ProfileService
        static let liveValue: ProfileService = ProfileServiceImpl(baseURL: baseURL)
    }
    
    var profileService: ProfileService {
        get { self[ProfileServiceKey.self] }
        set { self[ProfileServiceKey.self] = newValue }
    }
}
