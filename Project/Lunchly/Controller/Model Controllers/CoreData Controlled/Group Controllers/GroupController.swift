//
//  GroupController.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class GroupController {
    //MARK: Class Properties
    weak var delegate: CoreDataController? {
        didSet {
            createGroups()
        }
    }
    var groups: [Group] = []
    var meetupController = MeetupController()
    
    //MARK: Set Child Controller Delegate
    init() {
        meetupController.delegate = self
    }
    
    //MARK: Create
    func createGroups() {
        load()
        if groups.count == 0 {
            let dineInImage = UIImage(systemName: "tray.and.arrow.down.fill")!
            let takeOutImage = UIImage(systemName: "tray.and.arrow.up.fill")!
            let deliveryImage = UIImage(systemName: "car.fill")!
            let takeoutAndDeliveryImage = UIImage(systemName: "person.3.fill")!
            let allImage = UIImage(systemName: "tray.2.fill")!
            groups = [
                Group(name: "Kenny's Dine in only group", imageData: dineInImage.jpegData(compressionQuality: 1.0)!, serviceTypes: [.dineIn]),
                Group(name: "James's Delivery only group", imageData: deliveryImage.jpegData(compressionQuality: 1.0)!, serviceTypes: [.delivery]),
                Group(name: "Aaron's Take Out only group", imageData: takeOutImage.jpegData(compressionQuality: 1.0)!, serviceTypes: [.takeout]),
                Group(name: "Michael's Take Out and Dine In group", imageData: takeoutAndDeliveryImage.jpegData(compressionQuality: 1.0)!, serviceTypes: [.takeout, .dineIn]),
                Group(name: "Tobi's Everything Group", imageData: allImage.jpegData(compressionQuality: 1.0)!, serviceTypes: [.viewAll])
            ]
            save()
        }
    }
    
    //MARK: Read:
    func load() {
        delegate?.loadGroupsFromPersistentStore()
    }
    
    //MARK: Update
    func addGroup(group: Group) {
        groups.append(group)
        save()
    }
    
    func addUserToGroup(group: Group, user: User) {
        for (index, thisGroup) in groups.enumerated() {
            //group found, mutate
            if group == thisGroup {
                for thisUser in group.users {
                    if thisUser == user {
                        return //user already exists
                    }
                }
                groups[index].users.append(user) //user doesn't exist, append to this group
                save()
            }
        }
    }
    
    func addRestaurantToGroup(group: Group, restaurant: Restaurant) {
        for (index, thisGroup) in groups.enumerated() {
            if group == thisGroup { //group found, replace
                for thisRestaurant in group.restaurants {
                    if thisRestaurant == restaurant {
                        print("restaurant Found, returning")
                        return //restaurant already exists in group
                    }
                }
                groups[index].restaurants.append(restaurant) //restaurant doesn't exist, append to this group
                save()
            }
        }
    }
    
    func updateImageData(group: Group, imageData: Data) {
        for (index, thisGroup) in groups.enumerated() {
            if group == thisGroup { //group found, replace
                groups[index].imageData = imageData
                save()
            }
        }
    }
    
    func addMeetupToGroup(group: Group, meetup: Meetup) {
        for (index, thisGroup) in groups.enumerated() {
            if group == thisGroup {
                for thisMeetup in groups[index].meetups {
                    if thisMeetup == meetup {
                        return
                    }
                }
                //meetup not found, append
                groups[index].meetups.append(meetup)
                save()
            }
        }
    }
    
    func updateMeetup(group: Group, originalMeetup: Meetup, amendedMeetup: Meetup) {
        for (index, thisGroup) in groups.enumerated() {
            print("updating meetup from group controller")
            if group == thisGroup {
                for (meetupIndex, thisMeetup) in groups[index].meetups.enumerated() {
                    if thisMeetup == originalMeetup { //meetup found
                        groups[index].meetups[meetupIndex] = amendedMeetup
                        save()
                    }
                }
            }
        }
    }
    
    func save() {
        delegate?.saveGroupsToPersistentStore()
    }
   
}
