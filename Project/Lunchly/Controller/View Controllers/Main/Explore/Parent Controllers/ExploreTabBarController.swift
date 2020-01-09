//
//  ExploreTabBarController.swift
//  Lunchly
//
//  Created by Kenny on 1/7/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ExploreTabBarController: UITabBarController {
    //MARK: Class Properties
    var coreDataController: CoreDataController?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("exploreTBC loaded")
        if self.coreDataController == nil {
            coreDataController = CoreDataController()
        }
        coreDataController?.groupsController.createGroups()
        coreDataController?.usersController.createUsers()
        coreDataController?.restaurantController.createRestaurants()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ExploreRootSegue" {
            if let destination = segue.destination as? ExploreNavController {
                destination.coreDataController = coreDataController
            }
        } else if segue.identifier == "UserProfileRootSegue" {
            if let destination = segue.destination as? UserNavigationController {
                destination.userController = coreDataController?.usersController
            }
        }
    }
    
}
