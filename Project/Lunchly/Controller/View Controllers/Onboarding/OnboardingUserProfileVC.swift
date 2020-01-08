//
//  OnboardingUserProfileVC.swift
//  Lunchly
//
//  Created by Kenny on 1/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingUserProfileVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    //MARK: IBActions
    @IBAction func skipButtonWasTapped(_ sender: Any) {
        SkipTutorial.skip(vc: self)
    }
    
    @IBAction func nextButtonWasTapped(_ sender: Any) {
        guard let delegate = delegate else {return}
        if !delegate.saveUser() {
                Alert.show(title: "Oops!", message: "Please Enter a Username", vc: self) {}
        
            } else {
                performSegue(withIdentifier: "CreateGroupSegue", sender: nil)
            }
    }
    
    weak var delegate: UserProfileVC?
    var coreDataConroller : CoreDataController?
    var userController: UserController?
    let settingsController = UserSettingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    //MARK: Helper Methods
    func updateViews() {
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingUserProfileSegue" { //containerView is loading UserProfileVC from main.storyboard
            guard let destination = segue.destination as? UserProfileVC else {return}
            destination.userController = userController
            delegate = destination
        } else if segue.identifier == "CreateGroupSegue" { //next button
            guard let destination = segue.destination as? OnboardingGroupProfileVC else {return}
            destination.coreDataController = coreDataConroller
            #warning("Implement Delegate Pattern")
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {

        return true
    }

}
