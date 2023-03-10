//
//  Resources+Strings.swift
//  Stravatar
//
//  Created by Tomislav Eric on 10.03.23.
//

import Foundation

enum LocalizationKey: String {
    case playerHRzonesTitle = "player_heartrate_zones_title"
    case playerHRzonesDescription = "player_heartrate_zones_description"
    case skillsHudTitle = "skills_hud_title"
    case activitiesTitle = "activities_title"
    
    //MARK: Strava
    case stravaProfileTitle = "strava_profile_title"
    
    //MARK: Avatar Info
    case avatarInfoTitle = "avatar_info_title"
    case avatarInfoName = "avatar_info_name"
    case avatarInfoAge = "avatar_info_age"

    //MARK: Avatar Creation
    case avatarCreationNameInput = "avatar_creation_name_input_title"
    case avatarCreationNameInputPlaceholder = "avatar_creation_name_input_placeholder"
    case avatarCreationButtonTitle = "avatar_creation_button_title"
    
    //MARK: Generic strings
    case placeholder = "placeholder"
}

extension String {
    init(_ key: LocalizationKey) {
        self.init(NSLocalizedString(key.rawValue, comment: ""))
    }
}
