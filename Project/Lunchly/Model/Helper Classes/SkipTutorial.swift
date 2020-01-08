//
//  SkipsTutorial.swift
//  Lunchly
//
//  Created by Kenny on 1/8/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import UIKit

class SkipTutorial {
    class func skip(vc: UIViewController) {
        let settingsController = UserSettingsController()
        settingsController.setUserSkipsTutorial()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Main"))
        if let tabbar = storyboard.instantiateViewController(withIdentifier: "GroupTabBarController") as? ExploreTabBarController {
            vc.present(tabbar, animated: true, completion: nil)
        }
    }
}
