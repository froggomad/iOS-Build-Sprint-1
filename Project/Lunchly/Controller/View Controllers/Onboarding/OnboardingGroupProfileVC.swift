//
//  OnboardingGroupProfileVC.swift
//  Lunchly
//
//  Created by Kenny on 1/6/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class OnboardingGroupProfileVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var skipTutorialOutlet: UIButton!
    
    //MARK: IBActions
    @IBAction func skipTutorialButtonWasTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(identifier: "Main"))
        if let tabbar = storyboard.instantiateViewController(withIdentifier: "GroupTabBarController") as? ExploreTabBarController {
            self.present(tabbar, animated: true, completion: nil)
        }
    }
        
    //MARK: Class Properties
    var coreDataController: CoreDataController?
    var currentUser: User?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OnboardingGroupProfileSegue" {
            guard let destination = segue.destination as? GroupDetailVC else {return}
            currentUser = coreDataController?.usersController.currentUser
            destination.coreDataController = coreDataController
            guard let currentUser = currentUser else {return}
            var defaultGroup = Group(categoryType: .group, name: "Enter Group Name", imageData: UIImage(systemName: "person.3.fill")?.jpegData(compressionQuality: 1) ?? Data(), serviceTypes: [.dineIn,.delivery,.takeout], users: [], restaurants: [], meetups: [])
            if currentUser.groups.count == 0 {
                coreDataController?.groupsController.addGroup(group: defaultGroup)
                coreDataController?.groupsController.addUserToGroup(group: defaultGroup, user: currentUser)
                coreDataController?.usersController.addGroupToUser(group: defaultGroup, user: currentUser)
                defaultGroup.users.append(currentUser)
                destination.group = defaultGroup
            }
            
        }
    }
    

}
