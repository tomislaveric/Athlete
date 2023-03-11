//
//  Profile.swift
//  Stravatar
//
//  Created by Tomislav Eric on 17.02.23.
//

import Foundation
import PlayerEngine

struct Profile: Equatable {
    let name: String?
    var hrZones: [Zone]?
    var activities: [Activity]?
}
