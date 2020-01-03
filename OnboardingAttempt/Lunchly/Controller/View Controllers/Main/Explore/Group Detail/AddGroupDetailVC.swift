//
//  AddGroupDetailVC.swift
//  Lunchly
//
//  Created by Kenny on 12/28/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class AddGroupDetailVC: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var tableView: UITableView!
    #warning("TODO: filter by search text")
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:IBActions
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Class Properties
    var group: Group?
    //controllers
    var groupController: GroupController?
    var restaurantController: RestaurantController?
    var userController: UserController?
    //[Any] to be able to hold either users or restaurants for adding to group
    var tableViewDataSource: [Any]?
    
    //MARK: Class Delegates
    weak var delegate: GroupDetailVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    func updateViews() {
        guard let group = group else {return}
        if let restaurantController = restaurantController {
            var groupRestaurantArray: [String] = []
            for restaurant in group.restaurants {
                groupRestaurantArray.append(restaurant.name)
            }
            var remainingRestaurantArray: [Restaurant] = []
            for coreRestaurant in restaurantController.restaurants {
                if !groupRestaurantArray.contains(coreRestaurant.name) {
                    remainingRestaurantArray.append(coreRestaurant)
                }
            }
            var filteredRestaurantArray: [Restaurant] = []
            for restaurant in remainingRestaurantArray {
                for serviceType in group.serviceTypes {
                    if restaurant.serviceTypes.contains(serviceType) {
                        filteredRestaurantArray.append(restaurant)
                    }
                }
            }
            tableViewDataSource = filteredRestaurantArray
        } else if let userController = userController {
            var groupUserArray: [String] = []
            for user in group.users {
                groupUserArray.append(user.name)
            }
            var remainingUserArray: [User] = []
            for coreUser in userController.users {
                if !groupUserArray.contains(coreUser.name) {
                    remainingUserArray.append(coreUser)
                }
            }
            tableViewDataSource = remainingUserArray
            print("#remaining users: \(remainingUserArray.count)")
        }
    }
    
    func updateGroup(group: Group) {
        self.group = group
        print("updating group from AddGroupDetailVC")
        delegate?.updateGroup(group: group)
        self.dismiss(animated: true, completion: nil)
    }

}

extension AddGroupDetailVC: UITableViewDelegate {
    
}

extension AddGroupDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableViewDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.userController != nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddMemberCell", for: indexPath) as? AddMemberCell,
                  let member = tableViewDataSource?[indexPath.row] as? User,
                  let group = group
                else {return UITableViewCell()}
            var memberGroupsArray: [String] = []
            for group in member.groups {
                memberGroupsArray.append(group.name)
            }
            if !memberGroupsArray.contains(group.name) {
                print("configuring cell")
                cell.delegate = self
                cell.member = member
                cell.group = group
                cell.groupController = groupController
                cell.userController = userController
                cell.backgroundColor = .clear
                return cell
            }
        } else if self.restaurantController != nil {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddRestaurantCell", for: indexPath) as? AddRestaurantToGroupCell,
                    let restaurant = tableViewDataSource?[indexPath.row] as? Restaurant,
                    let group = group
                else {return UITableViewCell()}
            
            var groupRestaurantsArray: [String] = []
            for memberRestaurant in group.restaurants {
               groupRestaurantsArray.append(memberRestaurant.name)
            }
            if !groupRestaurantsArray.contains(restaurant.name) {
                cell.delegate = self
                cell.backgroundColor = .clear
                cell.restaurant = restaurant
                cell.group = group
                cell.groupController = groupController
                return cell
            }
        }
        return UITableViewCell()
    }
    
    
}
