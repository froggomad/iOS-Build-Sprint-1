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
    
    //Custom DataType Controllers
    var restaurantController = RestaurantController()
    var groupsController = GroupController()
    
    //MARK: Init
    init() {
        self.decoder = PropertyListDecoder()
        self.encoder = PropertyListEncoder()
        restaurantController.delegate = self
        groupsController.delegate = self
    }
    
    //MARK: decode Data
    private func decodeRestaurantData() throws -> [Restaurant] { //throwing to use in do/let/try
        guard let fileData = dataFromFileUrl(fileName: "restaurants.plist") else { return [] }
        do {
            return try decoder.decode([Restaurant].self, from: fileData)
        } catch {
            print("error decoding restaurant file \(error)")
        }
        return []
    }
    
    private func decodeGroupData() throws ->  [Group] {
        guard let fileData = dataFromFileUrl(fileName: "groups.plist") else { return [] }
        do {
            return try decoder.decode([Group].self, from: fileData)
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
            print(restaurantController.restaurants)
        } catch {
            print("Error loading restaurants from plist: \(error)")
        }
    }
    
    func loadGroupsFromPersistentStore() {
      do {
          let groupArray = try decodeGroupData()
          self.groupsController.groups = groupArray
          print(groupsController.groups)
      } catch {
          print("Error loading restaurants from plist: \(error)")
      }
    }
    
    //MARK: Encode Data for updating
    private func encodeRestaurantData() throws -> Data { //throwing to use in do/let/try
       do {
        print("Restaurants: \(restaurantController.restaurants)")
        return try encoder.encode(restaurantController.restaurants)
       } catch {
           print("error encoding restaurant file \(error)")
       }
       return Data()
   }
    
       
    //MARK: Update
    func saveRestaurantsToPersistentStore() {
        guard let fileUrl = fileUrl(fromFileName: "restaurants.plist", inDirectory: .documentDirectory) else {
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

    //MARK: Delete
    func removeFromPersistentStore() {
       
   }
    
    //MARK: Helper Methods
    
    //create fileUrl from filename and directory
    private func fileUrl(fromFileName file: String, inDirectory directory: FileManager.SearchPathDirectory) -> URL? {
        let fileManager = FileManager.default
        print(directory.rawValue)
        guard let directory = fileManager.urls(for: directory, in: .userDomainMask).first else {print("directory invalid"); return nil}
        let fileUrl = directory.appendingPathComponent(file)
        print(fileUrl)
        return fileUrl
    }
    
    //create data from fileUrl
    private func dataFromFileUrl(fileName file: String) -> Data? {
        guard let fileUrl = fileUrl(fromFileName: file, inDirectory: .documentDirectory) else {
            print("returning empty restaurant array, couldn't construct fileURL")
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
