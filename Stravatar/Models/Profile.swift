//
//  Profile.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//

import Foundation
import AvatarService

struct Profile: Equatable {
    var hrZones: [Zone]?
    var activities: [Activity]?
    var connections: [Connection]?
    var activeConnection: Connection?
}

struct Connection: Equatable {
    let id: String?
    let type: ConnectionType
}

enum ConnectionType: String, Equatable {
    case strava = "Strava"
    case garmin = "Garmin"
    case none
}
