//
//  UserNavigationController.swift
//  Lunchly
//
//  Created by Kenny on 1/7/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class UserNavigationController: UINavigationController {
    //MARK: Class Proerties
    var userController: UserController?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProfileSegue" {
            if let destination = segue.destination as? UserProfileVC {
                destination.userController = userController
            }
        }
    }
    

}
