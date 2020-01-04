//
//  RestaurantController.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation
import UIKit

class RestaurantController {
    //MARK: Class Properties
    weak var delegate: CoreDataController? {
        didSet {
            createRestaurants()
        }
    }
    var restaurants: [Restaurant] = []
    
    //MARK: Create
    func createRestaurants() {
        delegate?.loadRestaurantsFromPersistentStore()
        if restaurants.count == 0 {
            print("creating restaurants")
            //MARK: Hard-coded Restaurant Data
            let pizzaImage = UIImage(named: "whole-pizza")
            let statesImage = UIImage(named: "statesCoffee")
            let mountainImage = UIImage(named: "mountainGrounds")
            let lemongrassImage = UIImage(named: "lemongrassBistro")
            let barrelistaImage = UIImage(named: "barrelistaCoffee")
            
            restaurants = [
                Restaurant(name: "Joe's Pizza Shack", imageData: pizzaImage?.pngData() ?? Data(), address: "123 Main St.\nMartinez, CA 94553", serviceTypes: [.takeout, .delivery]),
                Restaurant(name: "State's Coffee", imageData: statesImage?.pngData() ?? Data(), address: "609 Ward St.\nMartinez, CA 94553", serviceTypes: [.takeout, .dineIn]),
                Restaurant(name: "Mountain Grounds", imageData: mountainImage?.pngData() ?? Data(), address: "3750 Alhambra Ave. #2\nMartinez, CA 94553", serviceTypes: [.takeout, .dineIn]),
                Restaurant(name: "Lemongrass Bistro", imageData: lemongrassImage?.pngData() ?? Data(), address: "501 Main St.\nMartinez, CA 94553",serviceTypes: [.takeout, .dineIn]),
                Restaurant(name: "Barrelista Coffee House", imageData: barrelistaImage?.pngData() ?? Data(), address: "736 Main St.\n Martinez, CA 94553", serviceTypes: [.takeout, .dineIn]),
            ]
            delegate?.saveRestaurantsToPersistentStore()
        }
    }
    
    //MARK: Read
    func getRestaurantFromName(name: String) -> Restaurant? { //currently unused
        for restaurant in restaurants {
            if restaurant.name == name {
                return restaurant
            }
        }
        return nil
    }
    
    func load() {
        delegate?.loadRestaurantsFromPersistentStore()
    }
    
    //MARK: Update
    func updateRestaurant(oldRestaurant: Restaurant, newRestaurant: Restaurant) {
        for (index, thisRestaurant) in restaurants.enumerated() where thisRestaurant == oldRestaurant {
            restaurants[index].name = newRestaurant.name
            restaurants[index].imageData = newRestaurant.imageData
            delegate?.saveRestaurantsToPersistentStore()
        }
    }
        
}
