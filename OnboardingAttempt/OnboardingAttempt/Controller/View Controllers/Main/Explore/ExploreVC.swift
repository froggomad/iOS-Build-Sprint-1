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
    @IBOutlet weak var searchBarView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var coreDataController: CoreDataController?
    var searchable: [Searchable] = []
//    var categories: [Category]?
//    var restaurants: [Restaurant]?
//    var groups: [Group]?
    
    
    //MARK: View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //set delegates
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        searchBar.delegate = self
        searchBar.searchTextField.delegate = self
        
        //MARK: CollectionView DataSource testing
        self.coreDataController = CoreDataController()
        coreDataController?.restaurantController.createRestaurants()
        
        if let restaurants = coreDataController?.restaurantController.restaurants {
            for restaurant in  restaurants {
                self.searchable.append(restaurant)
            }
            print("Searchable: \(searchable)")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }
    
    //MARK: Helper Methods
    func constructCategoryImageArray() {
        
    }
}

//MARK: Collection Views
extension ExploreVC: UICollectionViewDelegate {
    
}

extension ExploreVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case categoryCollectionView:
            return 1
        case searchResultsCollectionView:
            return searchable.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
            case categoryCollectionView:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCell else {print("no category cells"); return UICollectionViewCell()}
                return cell
            case searchResultsCollectionView:
                if let restaurantData = searchable[indexPath.row] as? Restaurant {
                    guard let restaurantCell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as? RestaurantCell else {return UICollectionViewCell()}
                    restaurantCell.restaurant = restaurantData
                    restaurantCell.setBorders(color: .black, width: 2, cornerRadius: 8)
                    return restaurantCell
                } else if let groupData = searchable[indexPath.row] as? Group {
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
//extension UISearchBar {
//    /// Returns the`UITextField` that is placed inside the text field.
//    var textField: UITextField {
//        if #available(iOS 13, *) {
//            return searchTextField
//        } else {
//            return self.value(forKey: "_searchField") as! UITextField
//        }
//    }
//}
