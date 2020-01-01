//
//  AddMeetupVC.swift
//  Lunchly
//
//  Created by Kenny on 12/30/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit
import UserNotifications

class AddMeetupVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //MARK: IBActions
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        self.meetupTime = datePicker.date
    }
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            Alert.inputForMeetupNotification(title: "Travel Time", message: "How long does it normally take you to get there?", vc: self) { time in
                guard let meetupTime = self.meetupTime else {
                    Alert.show(title: "Oops!", message: "Please enter a date above", vc: self)
                    return
                }
                self.timeToLeave = Calendar.current.date(byAdding: .minute, value: -time, to: meetupTime)
                self.notificationHandler.notificationRequest() //ask permission to send notifications in case user has changed preferences (doesn't ask if permission is already granted)
                #warning("Move the save call to the save button when it's implemented")
                self.save()
            }
        } else {
           //notification = nil
        }
    }
    
    
    //MARK: Class Properties
    weak var delegate: GroupDetailVC?
    
    var group: Group?
    var meetupTime: Date?
    var timeToLeave: Date?
    var groupController: GroupController?
    let notificationHandler = NotificationController()
    var pickedRestaurant: Restaurant?
    var pickedRestaurants: [Restaurant] = []
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = Date(timeIntervalSinceNow: 3600) //1 hour after now
        tableView.delegate = self
        tableView.dataSource = self
        notificationSwitch.isOn = false
    }
    
    //MARK: Helper Methods
    func save() {
        guard let timeToLeave = self.timeToLeave,
              let group = group else {return}
        let meetup = Meetup(name: "Test", location: "Here", meetupStarts: datePicker.date, id: "test")
        self.notificationHandler.triggerNotification(onDate: timeToLeave, withId: meetup.id)
        self.group?.meetups.append(meetup)
        groupController?.addMeetupToGroup(group: group, meetup: meetup)
        delegate?.updateGroup(group: self.group!)
        if pickedRestaurants.count == 1 {
            pickedRestaurant = pickedRestaurants[0]
        } else {
            //trigger vote
        }
    }
    

}

extension AddMeetupVC: UNUserNotificationCenterDelegate {
    
}

extension AddMeetupVC: UITableViewDelegate {
    
}

extension AddMeetupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group?.restaurants.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRestaurantToMeetupCell") as? GroupRestaurantCell else {return UITableViewCell()}
        cell.restaurant = group?.restaurants[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    
}
