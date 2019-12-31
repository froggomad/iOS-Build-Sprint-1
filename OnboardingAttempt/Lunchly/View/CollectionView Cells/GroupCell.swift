//
//  GroupCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    var group: Group? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Helper Methods
    func updateViews() {
        imageView.image = UIImage(data: group!.imageData)
        nameLabel.text = group!.name
    }
    
}
