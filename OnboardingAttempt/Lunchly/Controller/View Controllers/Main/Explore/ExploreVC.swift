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
    @IBOutlet weak var test: UICollectionView!
    @IBOutlet weak var searchResultsCollectionView: UICollectionView!
    
    //MARK: Search Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarView: UIView!
    
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
        test.delegate = self
        test.dataSource = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
        //MARK: CollectionView DataSource
        self.searchController = SearchController()
        self.coreDataController = CoreDataController()
        constructServiceArray()
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
        filteredSearchArray = searchable //copy searchable so there's a reference and one we filter for searching
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        searchable = []
        coreDataController?.loadGroupsFromPersistentStore()
        coreDataController?.loadRestaurantsFromPersistentStore()
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
        filteredSearchArray = searchable
        searchResultsCollectionView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchBar.textField.frame.size.height = 400
        searchBar.textField.layoutIfNeeded()
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
}

//MARK: Collection Views
extension ExploreVC: UICollectionViewDelegate {
    //MARK: DidSelectItem
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let thisCell = collectionView.cellForItem(at: indexPath) as? CategoryCell else {return} //to check for .viewAll who's cell is set to selected on instantiation (also ensures we have a CategoryCell, not a Restaurant or Group Cell)
        //filter searchResultsCollectionView by selected CategoryCell
        for cell in test.visibleCells {
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
                test.visibleCells[0].isSelected = false //de-select .viewAll cell if other cells are tapped
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
        case test:
            return servicesArray.count
        case searchResultsCollectionView:
            return filteredSearchArray.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case test:
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
                    groupCell.setBorders(color: .black, width: 2, cornerRadius: 8)
                    return groupCell
                }
            return UICollectionViewCell() //failed
        default:
            return UICollectionViewCell()
        }
    }
    
    
}

extension ExploreVC: UISearchBarDelegate {
    
}

extension ExploreVC: UISearchTextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//access SearchTextField to change height regardless of iOS
extension UISearchBar {
    /// Returns the`UITextField` that is placed inside the text field.
    var textField: UITextField {
        if #available(iOS 13, *) {
            return searchTextField
        } else {
            return self.value(forKey: "_searchField") as! UITextField
        }
    }
}
