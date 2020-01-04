//
//  RestaurantCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: SetupView
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    //MARK: Class Properties
    var address: String?
    
    //MARK: Helper Methods
    func updateViews() {
        setBorders(color: .label)
        imageView.image = UIImage(data: restaurant!.imageData)
        nameLabel.text = restaurant!.name
    }
    
}
