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
    weak var delegate: CoreDataController? {
        didSet {
            createGroups()
        }
    }
    var groups: [Group] = []
    
    //MARK: Create
    func createGroups() {
        delegate?.loadGroupsFromPersistentStore()
        if groups.count == 0 {
            print("creating groups")
            let dineInImg = UIImage(systemName: "person.3.fill")!
            groups = [
                Group(name: "Dine in only group", imageData: dineInImg.jpegData(compressionQuality: 1.0)!, serviceTypes: [.dineIn])
            ]
            delegate?.saveGroupsToPersistentStore()
        }
    }
    
    //MARK: Update
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
                delegate?.saveGroupsToPersistentStore()
            }
        }
    }
    
    func addRestaurantToGroup(group: Group, restaurant: Restaurant) {
        for (index, thisGroup) in groups.enumerated() {
            if group == thisGroup { //group found, mutate
                for thisRestaurant in group.restaurants {
                    if thisRestaurant == restaurant {
                        print("restaurant Found")
                        return //restaurant already exists in group
                    }
                }
                groups[index].restaurants.append(restaurant) //restaurant doesn't exist, append to this group
                delegate?.saveGroupsToPersistentStore()
                print(groups[index].restaurants)
            }
        }
    }
   
}