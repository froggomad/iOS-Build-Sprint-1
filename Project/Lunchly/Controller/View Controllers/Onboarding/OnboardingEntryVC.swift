//
//  OnboardingEntryVC.swift
//  Lunchly
//
//  Created by Kenny on 1/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingEntryVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    //MARK: IBActions
    @IBAction func skipButtonWasTapped(_ sender: Any) {
        SkipTutorial.skip(vc: self)
    }
    
    //MARK: Class Properties
    var coreDataController: CoreDataController?
    let settingsController = UserSettingsController()
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        coreDataController = CoreDataController()
        updateViews()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateUserSegue" {
            guard let destination = segue.destination as? OnboardingUserProfileVC else {return}
            destination.coreDataConroller = coreDataController
            destination.userController = coreDataController?.usersController
        }
    }
    
    //MARK: Helper Methods
    func updateViews() {
        
    }
    
}
