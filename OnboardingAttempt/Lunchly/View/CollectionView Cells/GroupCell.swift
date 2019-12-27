//
//  GroupCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class GroupCell: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    var group: Group? {
        didSet {
            updateViews()
        }
    }
    
    func updateViews() {
        imgView.image = UIImage(data: group!.imageData)
        nameLbl.text = group!.name
    }
}
