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
    
    var timeSample: Double? {
        Double(duration/heartRateTicks.count)
    }
}
