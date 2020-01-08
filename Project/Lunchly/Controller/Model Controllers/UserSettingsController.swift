//
//  UserSettingsController.swift
//  Lunchly
//
//  Created by Kenny on 1/7/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

import Foundation


class UserSettingsController {
    //MARK: Class Properties
    private let userDefaults = UserDefaults.standard
    
    var themePreference: String? {
        //print(userDefaults.string(forKey: .themePreferenceKey))
        return userDefaults.string(forKey: .themePreferenceKey)
    }
    
    var notificationPreference: Bool? {
        return userDefaults.bool(forKey: .notificationPreferenceKey)
    }
    
    var userSkipsTutorial: Bool? {
        return userDefaults.bool(forKey: .tutorialSkipKey)
    }
    
    //MARK: Helper Methods
    func setThemePreferenceToDark() {
        userDefaults.set("Dark", forKey: .themePreferenceKey)
    }
    
    func setThemePreferenceToLight() {
        userDefaults.set("Light", forKey: .themePreferenceKey)
    }
    
    func setNotificationPreference() {
        guard let notificationPreference = notificationPreference else {return}
        userDefaults.set(!notificationPreference, forKey: .notificationPreferenceKey)
    }
    
    func setUserSkipsTutorial() {
        userDefaults.set(true, forKey: .tutorialSkipKey)
    }
    
    init() {
        if themePreference == nil {
            setThemePreferenceToLight()
        }
    }
    
}

extension String {
    static let themePreferenceKey = "themePreference"
    static let notificationPreferenceKey = "notificationPreferences"
    static let tutorialSkipKey = "tutorialWasFinished"
}
