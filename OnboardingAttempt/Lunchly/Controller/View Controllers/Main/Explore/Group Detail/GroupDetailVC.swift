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
    @IBOutlet weak var groupNameLbl: UILabel!
    @IBOutlet weak var restaurantTableView: UITableView!
    @IBOutlet weak var membersTableView: UITableView!
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var group: Group?
    var groupController: GroupController?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.restaurantTableView.delegate = self
        self.restaurantTableView.dataSource = self
        self.membersTableView.delegate = self
        self.membersTableView.dataSource = self
        updateViews()
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        membersTableView.reloadData()
        restaurantTableView.reloadData()
    }
    
    func updateViews() {
        guard let group = group else {return}
        self.imageView.image = UIImage(data: group.imageData)
        self.groupNameLbl.text = group.name
    }
  
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddRestaurantSegue" {
            
        } else {
            if segue.identifier == "AddMemberSegue" {
                guard let destination = segue.destination as? AddGroupDetailVC else {return}
                destination.isMember = true
            }
        }
    }
}

extension GroupDetailVC: UITableViewDelegate {
    
}

extension GroupDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case restaurantTableView:
            return group?.restaurants.count ?? 0
        case membersTableView:
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
            return cell
        case membersTableView:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCell", for: indexPath) as? GroupMemberCell else {return UITableViewCell()}
            cell.user = group?.users[indexPath.row]
            return cell
        default: return UITableViewCell()
        }
    }
    
    
}
