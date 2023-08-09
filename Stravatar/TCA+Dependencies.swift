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
        typealias Value = UserService
        static let liveValue: UserService = UserServiceImpl(baseURL: baseURL)
    }
    
    var profileService: UserService {
        get { self[ProfileServiceKey.self] }
        set { self[ProfileServiceKey.self] = newValue }
    }
}
