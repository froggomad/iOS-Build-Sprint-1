//
//  CoreDataController.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation

class CoreDataController {
    
    private let decoder: PropertyListDecoder
    private let encoder: PropertyListEncoder
    private let restaurantFile = "restaurants.plist"
    private let groupFile = "groups.plist"
    private let userFile = "users.plist"
    
    //Custom DataType Controllers
    var restaurantController = RestaurantController()
    var groupsController = GroupController()
    var usersController = UserController()
    
    //MARK: Init
    init() {
        self.decoder = PropertyListDecoder()
        self.encoder = PropertyListEncoder()
        restaurantController.delegate = self
        groupsController.delegate = self
        usersController.delegate = self
    }
    
    //MARK: decode Data
    private func decodeRestaurantData() throws -> [Restaurant] { //throwing to use in do/let/try
        guard let fileData = dataFromFileUrl(fileName: restaurantFile) else { return [] }
        do {
            return try decoder.decode([Restaurant].self, from: fileData)
        } catch {
            print("error decoding restaurant file \(error)")
        }
        return []
    }
    
    private func decodeGroupData() throws ->  [Group] {
        guard let fileData = dataFromFileUrl(fileName: groupFile) else { return [] }
        do {
            return try decoder.decode([Group].self, from: fileData)
        } catch {
            print("error decoding Groups file \(error)")
        }
        return []
    }
    
    private func decodeUserData() throws -> [User] {
        guard let fileData = dataFromFileUrl(fileName: userFile) else { return [] }
        do {
            return try decoder.decode([User].self, from: fileData)
        } catch {
            print("error decoding Groups file \(error)")
        }
        return []
    }
    
    //MARK: Read
    func loadRestaurantsFromPersistentStore() {
        do {
            let restaurantArray = try decodeRestaurantData()
            self.restaurantController.restaurants = restaurantArray
        } catch {
            print("Error loading restaurants from plist: \(error)")
        }
    }
    
    func loadGroupsFromPersistentStore() {
      do {
          let groupArray = try decodeGroupData()
          self.groupsController.groups = groupArray
      } catch {
          print("Error loading restaurants from plist: \(error)")
      }
    }
    
    func loadUsersFromPersistentStore() {
        do {
            let userArray = try decodeUserData()
            self.usersController.users = userArray
        } catch {
            print("Error loading users from plist: \(error)")
        }
        
    }
    
    //MARK: Encode Data for updating
    private func encodeRestaurantData() throws -> Data { //throwing to use in do/let/try
       do {
        return try encoder.encode(restaurantController.restaurants)
       } catch {
           print("error encoding restaurant file \(error)")
       }
       return Data()
    }
    
    private func encodeGroupData() throws -> Data { //throwing to use in do/let/try
        do {
            return try encoder.encode(groupsController.groups)
        } catch {
            print("error encoding group file \(error)")
        }
        return Data()
    }
    
    private func encodeUserData() throws -> Data { //throwing to use in do/let/try
        do {
            return try encoder.encode(usersController.users)
        } catch {
            print("error encoding group file \(error)")
        }
        return Data()
    }
    
       
    //MARK: Update
    func saveRestaurantsToPersistentStore() {
        guard let fileUrl = fileUrl(fromFileName: restaurantFile, inDirectory: .documentDirectory) else {
            print("invalid file path")
            return
        }
        do {
            let restaurantData = try encodeRestaurantData()
            try restaurantData.write(to: fileUrl)
        } catch {
            print("Error saving restaurants \(error)")
        }
    }
    
    func saveGroupsToPersistentStore() {
        guard let fileUrl = fileUrl(fromFileName: groupFile, inDirectory: .documentDirectory) else {
            print("invalid file path")
            return
        }
        do {
            let groupData = try encodeGroupData()
            try groupData.write(to: fileUrl)
        } catch {
            print("Error saving groups \(error)")
        }
    }
    
    func saveUsersToPersistentStore() {
        guard let fileUrl = fileUrl(fromFileName: userFile, inDirectory: .documentDirectory) else {
            print("invalid file path")
            return
        }
        do {
            let userData = try encodeUserData()
            try userData.write(to: fileUrl)
        } catch {
            print("Error saving users \(error)")
        }
    }
    
    func updateRestaurant(oldRestaurant: Restaurant, newRestaurant: Restaurant) {
        for (index, thisRestaurant) in restaurantController.restaurants.enumerated() where thisRestaurant == oldRestaurant {
            restaurantController.restaurants[index].name = newRestaurant.name
            restaurantController.restaurants[index].imageData = newRestaurant.imageData
            saveRestaurantsToPersistentStore()
        }
    }
    
    func updateGroup(forIndexPath indexPath: IndexPath) {
         
     }
     
     func updateUser(forIndexPath indexPath: IndexPath) {
         
     }

     //MARK: Delete
     func removeFromPersistentStore() {
        
    }
     
     //MARK: Helper Methods
     
     //create fileUrl from filename and directory
     private func fileUrl(fromFileName file: String, inDirectory directory: FileManager.SearchPathDirectory) -> URL? {
         let fileManager = FileManager.default
         guard let directory = fileManager.urls(for: directory, in: .userDomainMask).first else {print("directory invalid"); return nil}
         let fileUrl = directory.appendingPathComponent(file)
         return fileUrl
     }
     
     //create data from fileUrl
    private func dataFromFileUrl(fileName file: String) -> Data? {
        guard let fileUrl = fileUrl(fromFileName: file, inDirectory: .documentDirectory) else {
            print("returning empty data, couldn't construct fileURL")
            return nil
        }
        do {
            let fileData = try Data(contentsOf: fileUrl)
            return fileData
        } catch {
            print("error creating Data from fileUrl \(error)")
        }
        return nil
         
    }
    
}
