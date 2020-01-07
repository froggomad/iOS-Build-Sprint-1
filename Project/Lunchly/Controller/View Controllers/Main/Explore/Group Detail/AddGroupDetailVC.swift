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
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK:IBActions
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Class Properties
    weak var delegate: GroupDetailVC?
    var group: Group?
    //controllers
    var groupController: GroupController?
    var restaurantController: RestaurantController?
    var userController: UserController?
    #warning("Could use a protocol here instead of Any")
    //[Any] to be able to hold either users or restaurants for adding to group
    var tableViewDataSource: [Any]?
    
    //MARK: View Lifecycle (update view)
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.keyboardHidesOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateViews()
    }
    
    //MARK: Helper Methods
    func updateViews() {
        guard let group = group else {return}
        //if there's a restaurant controller, we're displaying restaurants
        if let restaurantController = restaurantController {
            var groupRestaurantArray: [String] = []
            //equatable didn't seem to be working properly, so I used an array of strings to compare restaurants
            for restaurant in group.restaurants {
                groupRestaurantArray.append(restaurant.name)
            }
            var remainingRestaurantArray: [Restaurant] = []
            for coreRestaurant in restaurantController.restaurants {
                //if the restaurant in the groupController doesn't equal the restaurant in the group's array, append it to the remainingRestaurant Array
                if !groupRestaurantArray.contains(coreRestaurant.name) {
                    remainingRestaurantArray.append(coreRestaurant)
                }
            }
            var filteredRestaurantArray: [Restaurant] = []
            //filter restaurant by serviceTypes the group allows
            for restaurant in remainingRestaurantArray {
                for serviceType in group.serviceTypes {
                    if restaurant.serviceTypes.contains(serviceType) {
                        filteredRestaurantArray.append(restaurant)
                    }
                }
            }
            //only show restaurants with allowed service types in the tableView's array
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
//MARK: TableView DataSource
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
            cell.selectionStyle = .none
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
            cell.selectionStyle = .none
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
