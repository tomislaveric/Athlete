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
    
    init(detailedActivity: DetailedActivity) {
        self.id = detailedActivity.id
        self.name = detailedActivity.name ?? ""
        self.hasHeartRate = detailedActivity.has_heartrate ?? false
    }
}
