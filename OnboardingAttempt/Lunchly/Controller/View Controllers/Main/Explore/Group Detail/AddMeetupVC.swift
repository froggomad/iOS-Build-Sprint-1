//
//  AddMeetupVC.swift
//  Lunchly
//
//  Created by Kenny on 12/30/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit
import UserNotifications

class AddMeetupVC: UIViewController, UpdatesMeetup {
    //MARK: IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var meetupNameTextField: UITextField!
    
    //MARK: IBActions
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func datePickerChanged(_ sender: Any) {
        self.meetupTime = datePicker.date
        datePicker.minimumDate = Date(timeIntervalSinceNow: 3600) //ensures minimum time is always one hour after now
    }
    
    @IBAction func notificationSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.notificationHandler.notificationRequest() //ask permission to send notifications in case user has changed preferences (doesn't ask if permission is already granted)
        }
    }
    
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        save()
    }
    
    
    
    //MARK: Class Properties
    private let minimumDate: Date? = Date(timeIntervalSinceNow: 3600)
    weak var delegate: GroupDetailVC?
    //meetup properties
    var meetupTime: Date?
    var pickedRestaurant: Restaurant?
    var pickedRestaurants: [Restaurant] = []
    //model/model controllers
    var group: Group?
    var groupController: GroupController?
    let notificationHandler = NotificationController()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.minimumDate = minimumDate
        datePicker.date = minimumDate ?? Date(timeIntervalSinceNow: 3600)
        self.meetupTime = datePicker.date
        tableView.delegate = self
        tableView.dataSource = self
        notificationSwitch.isOn = false
    }
    
    //MARK: Helper Methods
    func constructMeetup() -> Meetup? {
        guard let group = group else {return nil}
        guard let meetupTime = self.meetupTime else {
            Alert.show(title: "Time not entered", message: "Please Choose a Time to Leave", vc: self)
            return nil
        }
        guard let meetupName = meetupNameTextField.text,
                   meetupName != ""
               else {
                   Alert.show(title: "Name not entered", message: "Please type a name for your Meetup", vc: self)
                  return nil
               }
        var meetup: Meetup
        if pickedRestaurant != nil {
            meetup = Meetup(id: "\(group.name)-\(meetupTime)", name: meetupName, meetupStarts: meetupTime, possibleRestaurants: pickedRestaurants)
        } else {
            meetup = Meetup(id: "\(group.name)-\(meetupTime)", name: meetupName, meetupStarts: meetupTime, possibleRestaurants: pickedRestaurants)
        }
        return meetup
    }
    
    func setPickedRestaurant() {
        if pickedRestaurants.count == 0 {
            Alert.show(title: "No Restaurant Chosen", message: "Please Choose at least one Restaurant", vc: self)
            return
        } else if pickedRestaurants.count == 1 {
            pickedRestaurant = pickedRestaurants[0]
        }
    }
    
    func checkNotifications(meetup: Meetup) {
        if notificationSwitch.isOn {
            if let pickedRestaurant = pickedRestaurant {
                Alert.inputForMeetupNotification(title: "Travel Time", message: "How long does it normally take you to get to \(pickedRestaurant.name)?", vc: self) { time, status in
                    if status { //the input returned is an Int, set the meetup's timeToLeave and trigger the notification for when it's time to leave for the meetup
                        let timeToLeave = Calendar.current.date(byAdding: .minute, value: -time, to: meetup.meetupStarts)
                        self.notificationHandler.triggerNotification(onDate: timeToLeave!, withId: meetup.id)
                    } else {
                        self.notificationSwitch.isOn = false
                        Alert.show(title: "Oops!", message: "Please enter a number", vc: self)
                    }
                }
            } else {
              //trigger vote notification
            }
        }
    }
    
    func save() {
        setPickedRestaurant() //sets self.pickedRestaurant if only 1 restaurant is picked
        if self.meetupTime == nil {
            Alert.show(title: "Time not entered", message: "Please Choose a Time to Leave", vc: self)
            return
        }
        guard let group = group,
              let meetup = constructMeetup()
        else {return}
        checkNotifications(meetup: meetup)
        
        //save meetup
        //group is force unwrapped because we definitely have a group at this point
        self.group!.meetups.append(meetup)
        groupController?.addMeetupToGroup(group: group, meetup: meetup)
        delegate?.updateGroup(group: self.group!)
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateRestaurantSelection(restaurant: Restaurant) {
        for (index, pickedRestaurant) in pickedRestaurants.enumerated() {
            if pickedRestaurant == restaurant {
                pickedRestaurants.remove(at: index)
                return
            }
        }
        pickedRestaurants.append(restaurant)
    }
}

extension AddMeetupVC: UITableViewDelegate {
    
}

extension AddMeetupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group?.restaurants.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRestaurantToMeetupCell") as? VoteRestaurantCell else {return UITableViewCell()}
        cell.restaurant = group?.restaurants[indexPath.row]
        cell.backgroundColor = .clear
        cell.delegate = self
        return cell
    }
}
