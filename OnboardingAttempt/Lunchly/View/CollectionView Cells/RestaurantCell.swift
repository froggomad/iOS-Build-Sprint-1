//
//  RestaurantCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var restaurant: Restaurant? {
        didSet {
            updateViews()
        }
    }
    var address: String?
    
    //MARK: Helper Methods
    func updateViews() {
        setBorders(color: .label)
        imageView.image = UIImage(data: restaurant!.imageData)
        nameLabel.text = restaurant!.name
    }
    
}
