//
//  AddRestaurantCell.swift
//  Lunchly
//
//  Created by Kenny on 12/29/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddRestaurantToGroupCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: IBActions
    @IBAction func addBtnTapped(_ sender: UIButton) {
        addRestaurantToGroup()
        guard let group = group else {return}
        delegate?.updateGroup(group: group)
    }
    
    //MARK: Class Properties
    weak var delegate: AddGroupDetailVC?
    var group: Group?
    var groupController: GroupController?
    
    //MARK: Setup View
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Helper Methods
    func updateViews() {
        nameLabel.text = restaurant?.name
    }
    
    func addRestaurantToGroup() {
        guard let group = group,
            let restaurant = restaurant
        else {return}
        groupController?.addRestaurantToGroup(group: group, restaurant: restaurant)
        self.group?.restaurants.append(restaurant)
    }
    
}
