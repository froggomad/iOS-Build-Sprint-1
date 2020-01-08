//
//  LetsGetStartedVC.swift
//  Lunchly
//
//  Created by Kenny on 1/7/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingLetsGetStartedVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    //MARK: IBActions
    @IBAction func LetsGetStartedWasTapped(_ sender: UIButton) {
        settingsController.setUserSkipsTutorial()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Main"))
        if let tabbar = storyboard.instantiateViewController(withIdentifier: "GroupTabBarController") as? ExploreTabBarController {
            self.present(tabbar, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func notificationSwitchWasToggled(_ sender: Any) {
        settingsController.setNotificationPreference()
        if notificationSwitch.isOn {
            notificationController.notificationRequest()
        }
    }
    
    //MARK: Class Properties
    var settingsController = UserSettingsController()
    var notificationController = NotificationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationSwitch.isOn = settingsController.notificationPreference ?? false
        
    }
    


}
