//
//  AddGroupDetailCell.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddGroupDetailCell: UITableViewCell {
    
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let delegate = delegate,
              let type = type else {return}
        
        switch type {
        case .meetup:
            delegate.performAddMeetupSegue()
        case .member:
            delegate.performAddMemberSegue()
        case .restaurant:
            delegate.performAddRestaurantSegue()
        }
    }
    
    weak var delegate: GroupDetailVC?
    var type: HeaderCellCategoryType?
    
    func updateViews(type: HeaderCellCategoryType) {
        self.type = type
    }

}
