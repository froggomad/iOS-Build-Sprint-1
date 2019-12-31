//
//  GroupDetailVC.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupDetailVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var meetupTableView: UITableView!
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var membersTableView: UITableView!
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var group: Group?
    var groupController: GroupController?
    var restaurantController: RestaurantController?
    var userController: UserController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantTableView.delegate = self
        self.restaurantTableView.dataSource = self
        self.membersTableView.delegate = self
        self.membersTableView.dataSource = self
        self.meetupTableView.delegate = self
        self.meetupTableView.dataSource = self
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        membersTableView.reloadData()
        restaurantTableView.reloadData()
    }
    
    func updateViews() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Secondary")
        guard let group = group else {return}
        self.imageView.image = UIImage(data: group.imageData)
        self.groupNameLabel.text = group.name
    }
  
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRestaurantSegue" {
            guard let destination = segue.destination as? AddGroupDetailVC else {return}
            destination.restaurantController = restaurantController
            destination.groupController = groupController
            destination.group = group
            destination.delegate = self
        } else if segue.identifier == "AddMemberSegue" {
                guard let destination = segue.destination as? AddGroupDetailVC else {return}
                destination.userController = userController
                destination.groupController = groupController
                destination.group = group
                destination.delegate = self
        } else if segue.identifier == "ImagePickerSegue" {
            guard let destination = segue.destination as? ChangeGroupImageVC else {return}
            destination.delegate = self
            destination.group = group
            destination.groupController = groupController
        }
    }
    
    //MARK: Helper Methods
    func updateGroup(group: Group) {
        self.group = group
        self.imageView.image = UIImage(data: group.imageData)
        print("updating group from GroupDetailVC")
        restaurantTableView.reloadData()
        membersTableView.reloadData()
    }
    
    @objc func performAddRestaurantSegue() {
        performSegue(withIdentifier: "AddRestaurantSegue", sender: nil)
    }
    @objc func performAddMemberSegue() {
        performSegue(withIdentifier: "AddMemberSegue", sender: nil)
    }
    @objc func performAddMeetupSegue() {
        performSegue(withIdentifier: "AddMeetupSegue", sender: nil)
    }
}

extension GroupDetailVC: UITableViewDelegate {
    #warning("TODO: swipe to delete")
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let addButton = UIButton(type: .contactAdd)
        switch tableView {
        case meetupTableView:
            addButton.setTitle("Add Meetup", for: .normal)
            addButton.addTarget(self, action: #selector(performAddMeetupSegue), for: .touchUpInside)
            return addButton
        case restaurantTableView:
            addButton.setTitle("Add Restaurant", for: .normal)
            addButton.addTarget(self, action: #selector(performAddRestaurantSegue), for: .touchUpInside)
            return addButton
        case membersTableView:
            addButton.setTitle("Add Member", for: .normal)
            addButton.addTarget(self, action: #selector(performAddMemberSegue), for: .touchUpInside)
            return addButton
        default:
            let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            return clearView
        }
    }
}

extension GroupDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case restaurantTableView:
            print("#restaurants: \(group?.restaurants.count)")
            print(group?.restaurants)
            return group?.restaurants.count ?? 0
        case membersTableView:
            print("#users: \(group?.users.count)")
            print(group?.users)
            return group?.users.count ?? 0
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case restaurantTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupRestaurantCell", for: indexPath) as? GroupRestaurantCell else {return UITableViewCell()}
            cell.restaurant = group?.restaurants[indexPath.row]
            cell.backgroundColor = .clear
            return cell
            
        case membersTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath) as? GroupMemberCell else {return UITableViewCell()}
            cell.user = group?.users[indexPath.row]
            cell.backgroundColor = .clear
            return cell
        default: return UITableViewCell()
        }
    }
}

