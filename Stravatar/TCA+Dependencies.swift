//
//  TCA+Dependencies.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import ComposableArchitecture

extension DependencyValues {
    
    var stravaApi: StravaUseCase {
        get { self[StravaUseCase.self] }
        set { self[StravaUseCase.self] = newValue }
    }
    
    private enum AvatarServiceKey: DependencyKey {
        typealias Value = AvatarService
        static let liveValue: AvatarService = AvatarServiceImpl(baseURL: "http://localhost:8080")
    }
    
    var avatarService: AvatarService {
        get { self[AvatarServiceKey.self] }
        set { self[AvatarServiceKey.self] = newValue }
    }
}
