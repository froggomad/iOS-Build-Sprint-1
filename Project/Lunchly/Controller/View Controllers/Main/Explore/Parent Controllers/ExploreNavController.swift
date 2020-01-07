//
//  ExploreNavController.swift
//  Lunchly
//
//  Created by Kenny on 1/7/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class ExploreNavController: UINavigationController {
    //MARK: Class Properties
    var coreDataController: CoreDataController?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ExploreVCSegue" {
            if let destination = segue.destination as? ExploreVC {
                destination.coreDataController = coreDataController
            }
        }
    }

}
