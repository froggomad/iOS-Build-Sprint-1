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
    @IBOutlet weak var segueButtonOutlet: UIButton!
    
    
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var group: Group?
    var groupController: GroupController?
    var restaurantController: RestaurantController?
    var userController: UserController?
    //Timer for updating meetupTableView to update remaining time
    var timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantTableView.delegate = self
        self.restaurantTableView.dataSource = self
        self.membersTableView.delegate = self
        self.membersTableView.dataSource = self
        self.meetupTableView.delegate = self
        self.meetupTableView.dataSource = self
        updateViews()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(updateMeetupTableView), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTableViews()
    }
    
    func updateViews() {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barTintColor = UIColor(named: "Secondary")
        guard let group = group else {return}
        self.imageView.image = UIImage(data: group.imageData)
        segueButtonOutlet.frame.size.width = imageView.image?.size.width ?? 0
        segueButtonOutlet.layoutIfNeeded()
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
        } else if segue.identifier == "AddMeetupSegue" {
            guard let destination = segue.destination as? AddMeetupVC else {return}
            destination.delegate = self
            destination.group = group
            destination.groupController = groupController
        } else if segue.identifier == "MeetupDetailSegue" {
            guard let destination = segue.destination as? MeetupDetailVC,
                  let row = meetupTableView.indexPathForSelectedRow?.row
                else {return}
            destination.meetup = group?.meetups[row]
            guard let meetupController = groupController?.meetupController else {return}
            destination.meetupController = meetupController
            destination.group = group
            #warning("Pass meetup controller once delegate patter with groupController is established")
        }
    }
    
    //MARK: Helper Methods
    func updateGroup(group: Group) {
        self.group = group
        self.imageView.image = UIImage(data: group.imageData)
        print("updating group from GroupDetailVC")
        reloadTableViews()
    }
    
    func reloadTableViews() {
        meetupTableView.reloadData()
        membersTableView.reloadData()
        restaurantTableView.reloadData()
    }
    
    @objc func updateMeetupTableView() {
        meetupTableView.reloadData()
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
        switch tableView {
        case meetupTableView:
            return constructHeaderView(type: .meetup, tableView: meetupTableView)
        case restaurantTableView:
            return constructHeaderView(type: .restaurant, tableView: restaurantTableView)
        case membersTableView:
            return constructHeaderView(type: .member, tableView: membersTableView)
        default:
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        default: return 40
        }
    }
    
    //MARK: Helper Methods
    func constructHeaderView(type: HeaderCellCategoryType, tableView: UITableView) -> UIView {
        let clearView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        switch type {
        case .meetup:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "AddMeetupHeaderCell") as? AddGroupDetailCell else {return clearView}
            headerCell.delegate = self
            headerCell.updateViews(type: .meetup)
            headerCell.layoutMargins = .zero
            headerCell.backgroundColor = UIColor(named:"Primary")
            return headerCell
        case .restaurant:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "AddRestaurantHeaderCell") as? AddGroupDetailCell else {return clearView}
            headerCell.delegate = self
            headerCell.updateViews(type: .restaurant)
            headerCell.backgroundColor = UIColor(named:"Primary")
            return headerCell
        case .member:
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "AddMemberHeaderCell") as? AddGroupDetailCell else {return clearView}
            headerCell.delegate = self
            headerCell.updateViews(type: .member)
            headerCell.backgroundColor = UIColor(named:"Primary")
            return headerCell
        }
    }
}

extension GroupDetailVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case restaurantTableView:
            return group?.restaurants.count ?? 0
        case membersTableView:
            return group?.users.count ?? 0
        case meetupTableView:
            return group?.meetups.count ?? 0
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
        case meetupTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MeetupCell", for: indexPath) as? MeetupCell else { return UITableViewCell()}
            cell.meetup = group?.meetups[indexPath.row]
            cell.backgroundColor = .clear
            return cell
        default: return UITableViewCell()
        }
    }
}

