//
//  UserController.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation

class UserController {
    
    //MARK: Class Properties
    weak var delegate: CoreDataController? {
        didSet {
            createUsers()
        }
    }
    var users: [User] = []
    var currentUser: User? {
        return users[0]
    }
    
    //MARK: Create
    func createUsers() {
        load()
        if users.count == 0 {
            print("creating users")
            users = [
                User(name: "Enter Your Name", image: Data(), groups: [], restaurants: []),
                User(name: "TestUser", image: Data(), groups: [], restaurants: [])
            ]
            save()
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
    func addUser(user: User) {
        self.users.append(user)
        save()
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
                save()
            }
        }
    }
    
    func updateUser(originalUser: User, mutatedUser: User) {
        for (index, user) in users.enumerated() {
            if user == originalUser {
                users[index] = mutatedUser
                save()
                return
            }
        }
    }
    
    func save() {
        delegate?.saveUsersToPersistentStore()
    }
}

