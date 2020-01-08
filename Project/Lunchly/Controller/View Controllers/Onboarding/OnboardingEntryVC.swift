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
    var settingsController = UserSettingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    func updateViews() {
        coreDataController = CoreDataController()
        let skipsTutorial = settingsController.userSkipsTutorial ?? true
        if skipsTutorial {
            #warning("lol")
            Alert.show(title: "No", message: "You Don't Belong Here. Go Away", vc: self) {
                
            }
        }
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
