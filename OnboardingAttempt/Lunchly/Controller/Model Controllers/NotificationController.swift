//
//  Notification.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UserNotifications

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    
    //MARK: Class Properties
    let notificationCenter = UNUserNotificationCenter.current()
    private var date = Date()
    
    //MARK: Request permission
    func notificationRequest() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) {
           (didAllow, error) in
           if !didAllow {
               print("User has declined notifications")
           }
       }
    }
    
    func triggerNotification(notificationType: NotificationType, onDate date: Date, withId id: String) {
        self.date = date
        let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
        let identifier = id
        let request = UNNotificationRequest(identifier: identifier,
                                            content: scheduleNotification(notificationType: notificationType),
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            print("notification: \(request.identifier)")
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Helper Methods
    private func scheduleNotification(notificationType: NotificationType) -> UNMutableNotificationContent {
        print("Scheduling")
        let content = UNMutableNotificationContent()
        content.sound = .default
        switch notificationType {
        case .timeToLeave:
            content.title = "Time to Leave!"
            content.body = "Your meetup is happening soon, let's roll!"
        case .votingBegan:
            content.title = "Time to vote!"
            content.body = "One of your groups has scheduled a new meetup!"
        case .votingEndsSoon:
            content.title = "Voting ends soon!"
            content.body = "You only have about 30 minutes left to vote on your group's meetup location!"
        case .votingEnded:
            content.title = "Voting Finished"
            content.body = "Your group's meetup location has been set!"
        }
        //content.badge = 1 (can't figure out how to clear this)
        return content
    }
    

}


