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
    @IBOutlet weak var saveButtonOutlet: UIButton!
    
    //MARK: IBActions
    @IBAction func closeButtonTapped(_ sender: UIButton) {
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
    let userDefaultsController = UserSettingsController()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    //MARK: Helper Methods
    func setupViews() {
        datePicker.minimumDate = minimumDate
        datePicker.date = minimumDate ?? Date(timeIntervalSinceNow: 3600)
        self.meetupTime = datePicker.date
        tableView.delegate = self
        tableView.dataSource = self
        saveButtonOutlet.titlePadding()
        self.keyboardHidesOnTap()
        notificationSwitch.isOn = userDefaultsController.notificationPreference ?? false
    }
    func constructMeetup() -> Meetup? {
        guard let group = group else {return nil}
        guard let meetupTime = self.meetupTime else {
            Alert.show(title: "Time not entered", message: "Please Choose a Time to Leave", vc: self) {}
            return nil
        }
        guard let meetupName = meetupNameTextField.text,
            meetupName != ""
        else {
            Alert.show(title: "Name not entered", message: "Please enter a name for your Meetup", vc: self) {
                self.meetupNameTextField.becomeFirstResponder()
            }
            return nil
        }
        
        var meetup: Meetup
//        if pickedRestaurant != nil {
            meetup = Meetup(id: "\(group.name)-\(meetupTime)", name: meetupName, meetupStarts: meetupTime, possibleRestaurants: pickedRestaurants)
//        }
        
//        else {
//            meetup = Meetup(id: "\(group.name)-\(meetupTime)", name: meetupName, meetupStarts: meetupTime, possibleRestaurants: pickedRestaurants)
//        }
        return meetup
    }
    
    func setPickedRestaurant() {
        if pickedRestaurants.count == 1 {
            pickedRestaurant = pickedRestaurants[0]
        }
    }
    
    
    /**
     Checks to see if user has requested that notifications be enabled for this meetup
     - Parameter complete:`@escaping (_ status: Bool) -> ()`
     - Parameter status: if true, meetup should be saved, and ViewController should be dismissed
    */
    func checkNotifications(meetup: Meetup, complete: @escaping (_ status: Bool) -> ()) {
        if notificationSwitch.isOn {
            if let pickedRestaurant = pickedRestaurant {
                Alert.inputForMeetupNotification(title: "Travel Time", message: "How long does it normally take you to get to \(pickedRestaurant.name)?", vc: self) { time, status in
                    if status { //the input returned is an Int, set the meetup's timeToLeave and trigger the notification for when it's time to leave for the meetup
                        let timeToLeave = Calendar.current.date(byAdding: .minute, value: -time, to: meetup.meetupStarts)
                        
                        self.notificationHandler.triggerNotification(meetup: meetup, notificationType: .timeToLeave, onDate: timeToLeave!, withId: "\(meetup.id)-\(NotificationType.timeToLeave.rawValue)")
                        complete(true)
                    } else {
                        self.notificationSwitch.isOn = false
                        Alert.show(title: "Oops!", message: "Please enter a number", vc: self) {
                            complete(false)
                        }
                    }
                    
                }
            } else {
                if pickedRestaurants.count > 1 {
                    notificationHandler.triggerNotification(meetup: meetup, notificationType: .votingBegan, onDate: Date(timeIntervalSinceNow: 15), withId: "\(meetup.id)-\(NotificationType.votingBegan.rawValue)")
                    if let voteEnds = meetup.voteEnds {
                        if voteEnds > Date(timeIntervalSinceNow: 1800) {
                            notificationHandler.triggerNotification(meetup: meetup, notificationType: .votingEndsSoon, onDate: Date(timeInterval: -1800, since: voteEnds), withId: "\(meetup.id)-\(NotificationType.votingEndsSoon.rawValue)")
                        }
                    }
                    complete(true)
                }
            }
            UNUserNotificationCenter.current().getPendingNotificationRequests { (notification) in
                print(notification.description)
            }
        } else {
            complete(true)
        }
        
    }
    
    func save() {
        if !pickedRestaurants.isEmpty {
            setPickedRestaurant() //sets self.pickedRestaurant if only 1 restaurant is picked
            
            if self.meetupTime == nil {
                Alert.show(title: "Time not entered", message: "Please Choose a Time to Leave", vc: self) {
                    
                }
                return
            }
            guard let group = group,
                  let meetup = constructMeetup()
            else {return}
            self.checkNotifications(meetup: meetup) { status in
                //save meetup
                //group is force unwrapped because we definitely have a group at this point
                if status {
                    self.group!.meetups.append(meetup)
                    self.groupController?.addMeetupToGroup(group: group, meetup: meetup)
                    self.delegate?.updateGroup(group: self.group!)
                    self.dismiss(animated: true, completion: nil)
                }
            } //This Doesn't appear to be blocking
            
        } else {
            Alert.show(title: "No Restaurant Chosen", message: "Please Choose at least one Restaurant", vc: self) {
                           
            }
        }
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
//MARK: TableView DataSource
extension AddMeetupVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.group?.restaurants.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRestaurantToMeetupCell") as? VoteRestaurantCell else {return UITableViewCell()}
        cell.selectionStyle = .none
        cell.restaurant = group?.restaurants[indexPath.row]
        cell.backgroundColor = .clear
        cell.delegate = self
        return cell
    }
}
