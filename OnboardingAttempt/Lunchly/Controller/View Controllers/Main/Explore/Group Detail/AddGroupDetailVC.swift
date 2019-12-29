//
//  AddGroupDetailVC.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddGroupDetailVC: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var findBtnOut: UIButton!
    
    @IBAction func findBtnTapped(_ sender: UIButton) {
        if isMember {
            addUserToGroup()
            self.dismiss(animated: true, completion: nil)
        } else {
            addRestaurantToGroup()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var group: Group?
    var restaurant: Restaurant?
    var groupController: GroupController?
    var restaurantController: RestaurantController?
    var userController: UserController?
    var isMember = false
    weak var delegate: GroupDetailVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        if isMember {
            nameTextField.placeholder = "Enter Member's name"
            findBtnOut.setTitle("Add Member", for: .normal)
        } else {
            nameTextField.placeholder = "Enter Restaurant's name"
            findBtnOut.setTitle("Add Restaurant", for: .normal)
        }
    }
    
    func addUserToGroup() {
        guard let text = nameTextField.text,
              let group = group,
              let user = userController?.getUserFromName(username: text)
        else {return}
        groupController?.addUserToGroup(group: group, user: user)
        userController?.addGroupToUser(group: group, user: user)
        self.group?.users.append(user)
        updateGroup()
    }
    
    func addRestaurantToGroup() {
        guard let text = nameTextField.text,
              let group = group,
              let restaurant = restaurantController?.getRestaurantFromName(name: text)
            else {print("failed getting text, group, or restaurant");return}
        groupController?.addRestaurantToGroup(group: group, restaurant: restaurant)
        self.group?.restaurants.append(restaurant)
        updateGroup()
    }
    
    func updateGroup() {
        guard let group = group else {return}
        delegate?.updateGroup(group: group)
    }

}
