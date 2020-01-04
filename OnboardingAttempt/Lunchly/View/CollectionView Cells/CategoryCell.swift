//
//  CategoryCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    //MARK: SetupView
    //set .viewAll categry to active on instantiation
    var service: ServiceType? {
        didSet {
            guard let service = service else {return}
            switch service {
            case .viewAll:
                self.isSelected = true
                self.nameLabel.text = service.rawValue
            default:
            self.nameLabel.text = service.rawValue
            }
            
            setActive()
        }
    }
    
    //MARK: Helper Methods
    func setActive() {
        guard let service = service else {return}
        if self.isSelected {
            self.setBorders(color: UIColor(named: "Action")!)
            self.imageView.image = UIImage(named: "\(service.rawValue)Filled")!
        } else {
            self.setBorders(color: .clear)
            self.imageView.image = UIImage(named: service.rawValue)!
        }
    }
}
