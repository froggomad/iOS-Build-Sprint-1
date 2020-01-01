//
//  Notification.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UserNotifications

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    private var date = Date()
    
    //Request permission to present notifications
    func notificationRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
           (didAllow, error) in
           if !didAllow {
               print("User has declined notifications")
           }
       }
    }
    
    private func scheduleNotification() -> UNMutableNotificationContent {
        print("Scheduling")
        let content = UNMutableNotificationContent()
        content.title = "Time to Leave!"
        content.body = "Your meetup is happening soon, let's roll!"
        content.sound = .default
        //content.badge = 1
        
        return content
    }
    
    func triggerNotification(onDate date: Date, withId id: String) {
        self.date = date
        let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
        let identifier = id
        let request = UNNotificationRequest(identifier: identifier,
                                            content: scheduleNotification(),
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            print("request added for \(date)")
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
}


