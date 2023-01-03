//
//  Activity.swift
//  Stravatar
//
//  Created by Tomislav Eric on 03.01.23.
//

import Foundation
import StravaApi

struct Activity: Equatable {
    let id: Int
    let name: String
    private let hasHeartRate: Bool
    
    var isValid: Bool {
        return hasHeartRate
    }
    
    init(detailedactity: DetailedActivity) {
        self.id = detailedactity.id
        self.name = detailedactity.name ?? ""
        self.hasHeartRate = detailedactity.has_heartrate ?? false
    }
}
