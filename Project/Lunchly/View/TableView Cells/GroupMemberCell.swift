//
//  GroupMemberCell.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupMemberCell: UITableViewCell {
    //MARK: Class Properties
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //MARK: Setup View
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Helper Methods
    func updateViews() {
        self.nameLabel.text = user!.name
    }

}
