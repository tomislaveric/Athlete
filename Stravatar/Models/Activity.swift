//
//  Activity.swift
//  Stravatar
//
//  Created by Tomislav Eric on 03.01.23.
//

import Foundation

struct Activity: Equatable, Identifiable {
    let id: Int
    let name: String?
    let duration: Int
    let heartRateTicks: [Int]
    let sportsType: SportType
    
    var timeSample: Double? {
        guard heartRateTicks.count != 0 else {
            return nil
        }
        return Double(duration/heartRateTicks.count)
    }
}

enum SportType: String {
    case bike
    case run
    case unknown
}
