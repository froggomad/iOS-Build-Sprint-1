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
        SkipTutorial.skip(vc: self)
    }
    
    @IBAction func notificationSwitchWasToggled(_ sender: UISwitch) {
        NotificationSwitchUIHelper.instance.switchNotifications(sender)
    }
    
    //MARK: Class Properties
    var settingsController = UserSettingsController()
    var notificationController = NotificationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationSwitchUIHelper.instance.setupUI(notificationSwitch)
    }
    


}
