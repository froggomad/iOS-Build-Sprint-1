//
//  Notification.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationController: NSObject, UNUserNotificationCenterDelegate {
    
    //MARK: Class Properties
    let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private var date = Date()
    
    //MARK: Request permission
    func notificationRequest() {
        
        notificationCenter.requestAuthorization(options: options) {
           (didAllow, error) in
           if !didAllow {
               print("User has declined notifications")
           }
       }
    }
    
    func triggerNotification(meetup: Meetup, notificationType: NotificationType, onDate date: Date, withId id: String) {
        self.date = date
        let notificationDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationDate, repeats: false)
        let identifier = id
        let request = UNNotificationRequest(identifier: identifier,
                                            content: scheduleNotification(meetup: meetup, notificationType: notificationType),
                                            trigger: trigger)
        notificationCenter.add(request) { (error) in
            print("notification: \(request.identifier)")
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    func disableNotifications() {
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    //MARK: Helper Methods
    private func scheduleNotification(meetup: Meetup, notificationType: NotificationType) -> UNMutableNotificationContent {
        print("Scheduling")
        let content = UNMutableNotificationContent()
        content.sound = .default
        switch notificationType {
        case .timeToLeave:
            content.title = "Time to Leave!"
            content.body = "Your meetup at \(meetup.restaurant?.name ?? "Your group's restaurant") is happening soon, let's roll!"
        case .votingBegan:
            content.title = "Time to vote!"
            content.body = "One of your groups has scheduled a new meetup!"
        case .votingEndsSoon:
            content.title = "Voting ends soon!"
            content.body = "You only have about 30 minutes left to vote on your group's meetup location!"
        case .votingEnded:
            content.title = "Voting Finished"
            content.body = "Your group's meetup location has been set to \(meetup.restaurant?.name ?? "the winning vote")! Remember to go to your group's meetup and tell us how much time it'll take you to get there so we can send you a reminder!"
        }
        //content.badge = 1 (can't figure out how to clear this)
        return content
    }
    

}


