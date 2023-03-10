//
//  Resources+Strings.swift
//  Stravatar
//
//  Created by Tomislav Eric on 10.03.23.
//

import Foundation

enum LocalizationKey: String {
    case skillsHudTitle = "skills_hud_title"
    case profileTitle = "profile_title"
    case playerHRzonesTitle = "player_heartrate_zones_title"
    case playerHRzonesDescription = "player_heartrate_zones_description"
    case activitiesTitle = "activities_title"
    case placeholder = "placeholder"
}

extension String {
    init(key: LocalizationKey) {
        self.init(NSLocalizedString(key.rawValue, comment: ""))
    }
}
