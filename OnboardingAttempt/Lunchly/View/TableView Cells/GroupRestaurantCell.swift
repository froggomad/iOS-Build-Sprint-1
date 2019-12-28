//
//  GroupRestaurantCell.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupRestaurantCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        self.nameLbl.text = restaurant!.name
    }

}
