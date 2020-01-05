//
//  VoteRestaurantCell.swift
//  Lunchly
//
//  Created by Kenny on 1/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class VoteRestaurantCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var wasVotedOnOutlet: UIButton!
    
    //MARK: IBActions
    @IBAction func wasVotedOnTapped(_ sender: UIButton) {
        guard let  restaurant = restaurant else {return}
        let badgeImage = UIImage(systemName: "rectangle.fill.badge.checkmark")
        if wasVotedOnOutlet.image(for: .normal) == badgeImage {
            if self.reuseIdentifier == "AddRestaurantToMeetupCell" {
                wasVotedOnOutlet.setTitle("Add", for: .normal)
            } else {
                wasVotedOnOutlet.setTitle("Vote", for: .normal)
            }
            wasVotedOnOutlet.setImage(UIImage(systemName: "rectangle.badge.checkmark"), for: .normal)
        } else {
            wasVotedOnOutlet.setImage(badgeImage, for: .normal)
            wasVotedOnOutlet.setTitle("", for: .normal)
        }
        delegate?.updateRestaurantSelection(restaurant: restaurant)
    }
    
    //MARK: Setup View
    var restaurant: Restaurant? {
        didSet {
           updateViews()
        }
    }
    
    //MARK: Class Properties
    weak var delegate: UpdatesMeetup?
    var votes: [User] = []
    var pickedRestaurant: Restaurant?
    
    //MARK: Helper Methods
    @objc func disableBtn(_ notification: Notification) {
        if let restaurant = notification.userInfo?["restaurant"] as? Restaurant {
            self.wasVotedOnOutlet.isEnabled = false
            if self.restaurant != restaurant {
                self.wasVotedOnOutlet.setImage(nil, for: .normal)
                self.wasVotedOnOutlet.setTitle("", for: .normal)
            }
        }
        
    }
    
    func updateViews() {
        guard let restaurant = restaurant else {return}
        restaurantNameLabel.text = restaurant.name
        NotificationCenter.default.addObserver(self, selector: #selector(disableBtn(_:)), name: Notification.Name(rawValue: "changeSwitch"), object: nil)
    }
    
}
