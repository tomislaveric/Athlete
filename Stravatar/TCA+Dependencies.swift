//
//  TCA+Dependencies.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import ComposableArchitecture
import PlayerEngine

extension DependencyValues {
    
    var stravaApi: StravaUseCase {
        get { self[StravaUseCase.self] }
        set { self[StravaUseCase.self] = newValue }
    }
    
    private enum PlayerEngineKey: DependencyKey {
        typealias Value = PlayerEngine
        static let liveValue: PlayerEngine = PlayerEngineImpl()
    }
    
    var playerEngine: PlayerEngine {
        get { self[PlayerEngineKey.self] }
        set { self[PlayerEngineKey.self] = newValue }
    }
}
