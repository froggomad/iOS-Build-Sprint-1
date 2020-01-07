//
//  LetsGetStartedVC.swift
//  Lunchly
//
//  Created by Kenny on 1/7/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingLetsGetStartedVC: UIViewController {
    @IBAction func LetsGetStartedWasTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Main"))
        if let tabbar = storyboard.instantiateViewController(withIdentifier: "GroupTabBarController") as? ExploreTabBarController {
            self.present(tabbar, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    


}
