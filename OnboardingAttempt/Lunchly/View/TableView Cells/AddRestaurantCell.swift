//
//  AddRestaurantCell.swift
//  Lunchly
//
//  Created by Kenny on 12/29/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddRestaurantCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        addRestaurantToGroup()
        guard let group = group else {return}
        print(group.restaurants)
        delegate?.updateGroup(group: group)
    }
    
    weak var delegate: AddGroupDetailVC?
    var group: Group?
    var groupController: GroupController?
    
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        nameLabel.text = restaurant?.name
    }
    
    func addRestaurantToGroup() {
        guard let group = group,
            let restaurant = restaurant
        else {return}
        groupController?.addRestaurantToGroup(group: group, restaurant: restaurant)
        self.group?.restaurants.append(restaurant)
        print(self.group?.restaurants)
    }
    
}
