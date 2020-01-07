//
//  OnboardingEntryVC.swift
//  Lunchly
//
//  Created by Kenny on 1/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingEntryVC: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    @IBAction func skipButtonWasTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Main"))
        if let tabbar = storyboard.instantiateViewController(withIdentifier: "GroupTabBarController") as? ExploreTabBarController {
            self.present(tabbar, animated: true, completion: nil)
        }
    }
    
    var coreDataController: CoreDataController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataController = CoreDataController()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateUserSegue" {
            if let destination = segue.destination as? OnboardingUserProfileVC {
                destination.coreDataConroller = coreDataController
                destination.userController = coreDataController?.usersController
            }
        }
    }
}
