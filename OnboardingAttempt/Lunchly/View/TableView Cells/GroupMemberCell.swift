//
//  GroupMemberCell.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupMemberCell: UITableViewCell {
    @IBOutlet weak var nameLbl: UILabel!
    
    var user: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        self.nameLbl.text = user!.name
    }

}
