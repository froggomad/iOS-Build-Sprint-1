//
//  OnboardingUserProfileVC.swift
//  Lunchly
//
//  Created by Kenny on 1/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingUserProfileVC: UIViewController {
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var skipButtonWasTapped: UIButton!
    
    var coreDataConroller : CoreDataController?
    var userController: UserController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    //MARK: Helper Methods
    func updateViews() {
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingUserProfileSegue" {
            guard let destination = segue.destination as? UserProfileVC else {return}
            destination.userController = userController
        }
    }

}
