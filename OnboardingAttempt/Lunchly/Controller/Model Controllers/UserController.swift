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
    //MARK: Create
    func createUsers() {
        delegate?.loadUsersFromPersistentStore()
        if users.count == 0 {
            print("creating users")
            users = [
                User(name: "Kenny", image: Data(), groups: [], restaurants: []),
                User(name: "TestUser", image: Data(), groups: [], restaurants: [])
            ]
            delegate?.saveUsersToPersistentStore()
        }
    }
    
    //MARK: Read:
    func load() {
        delegate?.loadUsersFromPersistentStore()
    }
    
    func getUserFromName(username: String) -> User? {
        for user in users {
            if user.name == username {
                return user
            }
        }
        return nil
    }
    
    //MARK: Update
    
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

