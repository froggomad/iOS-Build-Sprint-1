//
//  AddMemberCell.swift
//  Lunchly
//
//  Created by Kenny on 12/29/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddMemberCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    
    //MARK: IBActions
    @IBAction func addBtnTapped(_ sender: UIButton) {
        addUserToGroup()
        guard let group = group else {return}
        delegate?.updateGroup(group: group)
    }
    
    //MARK: Class Properties
    weak var delegate: AddGroupDetailVC?
    var group: Group?
    var groupController: GroupController?
    var userController: UserController?
    
    //MARK: Setup View
    var member: User? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        self.nameLabel.text = member?.name
    }
    
    //MARK: Helper Methods
    func addUserToGroup() {
        guard let group = group,
              let user = member
        else {return}
        print("adding user to group")
        groupController?.addUserToGroup(group: group, user: user)
        userController?.addGroupToUser(group: group, user: user)
        self.group?.users.append(user)
    }

}


