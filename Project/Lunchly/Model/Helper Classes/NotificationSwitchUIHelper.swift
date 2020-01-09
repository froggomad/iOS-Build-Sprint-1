//
//  NotificationSwitchUIHelper.swift
//  Lunchly
//
//  Created by Kenny on 1/8/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit



class NotificationSwitchUIHelper {
    //access the class without creating an instance
    static let instance = NotificationSwitchUIHelper()
    
    let userSettingsController = UserSettingsController()
    let notificationController = NotificationController()
    var notificationSetting: Bool {
      return userSettingsController.notificationPreference ?? false
    }
    
    /**
     Change Notification Switch UI Based on UserSettings.
     - Parameter sender:`UISwitch` - The UISwitch used to toggle notifications
        
    */
    func setupUI(_ sender: UISwitch) {
        sender.isOn = notificationSetting
    }
    
    /**
     Change Notification Settings
     - Parameter sender:`UISwitch` - The UISwitch used to toggle notifications
        
    */
    func switchNotifications(_ sender: UISwitch) {
        userSettingsController.setNotificationPreference()
        if sender.isOn {
            notificationController.notificationRequest()
        } else {
            notificationController.disableNotifications()
        }
    }
}
