//
//  UserSettingsVC.swift
//  Lunchly
//
//  Created by Kenny on 1/8/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class UserSettingsVC: UIViewController {
    @IBOutlet weak var notificationSwitchOutlet: UISwitch!
    @IBAction func notificationSwitchWasChanged(_ sender: UISwitch) {
        NotificationSwitchUIHelper.instance.switchNotifications(sender)
    }
    
    let userSettingsController = UserSettingsController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationSwitchUIHelper.instance.setupUI(notificationSwitchOutlet)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
