//
//  UserController.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation

class UserController {
    weak var delegate: CoreDataController? {
        didSet {
            createUsers()
        }
    }
    var users: [User] = []
    
    func createUsers() {
        delegate?.loadGroupsFromPersistentStore()
        if users.count == 0 {
            print("creating users")
            users = [
                User(name: "Kenny", image: Data(), groups: [delegate!.groupsController.groups[0]], restaurants: []),
                User(name: "TestUser", image: Data(), groups: [], restaurants: [])
            ]
            delegate?.saveGroupsToPersistentStore()
        }
    }
    
    func getUserFromName(username: String) -> User? {
        for user in users {
            if user.name == username {
                return user
            }
        }
        return nil
    }
    
    func addGroupToUser(group: Group, user: User) {
        for userGroup in user.groups {
            if userGroup == group {
                return //this group is already in the list
            }
        }
        for (index,modelUser) in users.enumerated() {
            if user == modelUser {
                users[index].groups.append(group)
                delegate?.saveUsersToPersistentStore()
            }
        }
    }
}

