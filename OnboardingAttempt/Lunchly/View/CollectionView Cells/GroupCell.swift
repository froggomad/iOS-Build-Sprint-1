//
//  GroupCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: SetupView
    var group: Group? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Helper Methods
    func updateViews() {
        setBorders(color: .label)
        imageView.image = UIImage(data: group!.imageData)
        nameLabel.text = group!.name
    }
    
}
