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
    weak var delegate: CoreDataController?
    var restaurants: [Restaurant] = []
    
    //MARK: Create
    func createRestaurants() {
        delegate?.loadRestaurantsFromPersistentStore()
        if restaurants.count == 0 {
            print("creating restaurants")
            restaurants = [
                Restaurant(serviceTypes: [ServiceType.takeout.rawValue, ServiceType.delivery.rawValue], name: "Joe's Pizza Shack", imageData: Data())
            ]
            delegate?.saveRestaurantsToPersistentStore()
        }
    }
}
