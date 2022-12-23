//
//  TCA+Dependencies.swift
//  Stravatar
//
//  Created by Tomislav Eric on 22.12.22.
//

import Foundation
import ComposableArchitecture
import HTTPRequest

extension DependencyValues {
    private enum HTTPRequestKey: DependencyKey {
        typealias Value = HTTPRequest
        
        static let liveValue: HTTPRequest = HTTPRequestImpl()
    }
    
    var httpRequest: HTTPRequest {
        get { self[HTTPRequestKey.self] }
        set { self[HTTPRequestKey.self] = newValue }
    }
}
