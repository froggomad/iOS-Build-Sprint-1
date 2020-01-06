//
//  ExploreVCViewController.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class ExploreVC: UIViewController {
    //MARK: Collection View Outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    //MARK: Search Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    
    //MARK: Class Properties
    var coreDataController: CoreDataController?
    var searchController: SearchController?
    var searchable: [Searchable] = []
    var filteredSearchArray: [Searchable] = []
    var servicesArray: [ServiceType] = []
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchBar.delegate = self
        
        //MARK: CollectionView DataSource
        self.searchController = SearchController()
        if coreDataController == nil {
            self.coreDataController = CoreDataController()
        }
        constructServiceArray()
        constructSearchArray()
        
        self.keyboardHidesOnTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        //get data from Persistent Store
        searchable = []
        coreDataController?.loadGroupsFromPersistentStore()
        coreDataController?.loadRestaurantsFromPersistentStore()
        tallyVotes()
        //construct search array
        if let restaurants = coreDataController?.restaurantController.restaurants {
            for restaurant in  restaurants {
                self.searchable.append(restaurant)
            }
        }
        if let groups = coreDataController?.groupsController.groups {
            for group in  groups {
                self.searchable.append(group)
            }
        }
        //create copy used as tableView DataSource for filtering
        filteredSearchArray = searchable
        searchResultsCollectionView.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GroupDetailSegue" {
            guard let destination = segue.destination as? GroupDetailVC,
                  let cell = sender as? GroupCell,
                  let indexPath = self.searchResultsCollectionView!.indexPath(for: cell),
                  let group = filteredSearchArray[indexPath.item] as? Group
            else {return}
            destination.group = group
            destination.groupController = coreDataController?.groupsController
            destination.userController = coreDataController?.usersController
            destination.restaurantController = coreDataController?.restaurantController
        }
    }
    
    //MARK: Helper Methods
    func constructServiceArray() {
        guard let services = searchController?.categoryNames else {return}
        for service in services {
            guard let thisService = ServiceType(rawValue: service) else {
                print(service, " not a service")
                return
            }
            servicesArray.append(thisService)
        }
    }
    
    func constructSearchArray() {
        if let restaurants = coreDataController?.restaurantController.restaurants {
            for restaurant in  restaurants {
                self.searchable.append(restaurant)
            }
        }
        if let groups = coreDataController?.groupsController.groups {
            for group in  groups {
                self.searchable.append(group)
            }
        }
        filteredSearchArray = searchable //copy searchable so there's a reference to the original and one we filter for searching
    }
    
    func tallyVotes() {
        guard let groupsController = coreDataController?.groupsController else {return}
        for group in groupsController.groups {
            for meetup in group.meetups {
                groupsController.meetupController.tallyVotes(group: group, meetup: meetup)
            }
        }
    }
}

//MARK: Collection Views
extension ExploreVC: UICollectionViewDelegate {
    //MARK: DidSelectItem
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let thisCell = collectionView.cellForItem(at: indexPath) as? CategoryCell else {return} //to check for .viewAll who's cell is set to selected on instantiation (also ensures we have a CategoryCell, not a Restaurant or Group Cell)
        //filter searchResultsCollectionView by selected CategoryCell
        for cell in categoryCollectionView.visibleCells {
            if thisCell.service != .viewAll {
                filteredSearchArray = searchable.filter {
                    var serviceArr = [ServiceType]()
                    for service in $0.serviceTypes {
                        if service == thisCell.service {
                            serviceArr.append(service)
                        }
                    }
                    return serviceArr.count != 0
                }
                categoryCollectionView.visibleCells[0].isSelected = false //de-select .viewAll cell if other cells are tapped
            } else {
                filteredSearchArray = searchable
            }
            //set views on all CategoryCells
            if let cell = cell as? CategoryCell {
                cell.setActive()
            }
        }
        searchResultsCollectionView.reloadData()
    }
}

extension ExploreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return servicesArray.count
        case searchResultsCollectionView:
            return filteredSearchArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case categoryCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {return UICollectionViewCell()}
                cell.service = servicesArray[indexPath.item]
                return cell
            case searchResultsCollectionView:
                //handle restaurants
                if let restaurantData = filteredSearchArray[indexPath.item] as? Restaurant {
                    guard let restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as? RestaurantCell else {return UICollectionViewCell()}
                    restaurantCell.restaurant = restaurantData
                    return restaurantCell
                    //handle groups
                } else if let groupData = filteredSearchArray[indexPath.item] as? Group {
                    guard let groupCell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as? GroupCell else {return UICollectionViewCell()}
                    groupCell.group = groupData
                    return groupCell
                }
            return UICollectionViewCell() //failed
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

//MARK: Search Delegate
extension ExploreVC: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
    }
}

//extension ExploreVC: UISearchTextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }
//}
