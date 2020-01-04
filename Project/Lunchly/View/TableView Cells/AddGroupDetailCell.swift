//
//  AddGroupDetailCell.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddGroupDetailCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var addButtonOutlet: UIButton!
    
    
    //MARK: IBActions
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
    
    //MARK: Class Properties
    weak var delegate: GroupDetailVC?
    var type: HeaderCellCategoryType?
    
    //MARK: Setup View (triggered in GroupDetailVC)
    func updateViews(type: HeaderCellCategoryType) {
        self.type = type
    }

}
