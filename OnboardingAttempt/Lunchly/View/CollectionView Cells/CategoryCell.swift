//
//  CategoryCell.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    
    var service: ServiceType? {
        didSet {
            guard let service = service else {return}
            switch service {
            case .delivery:
                self.nameLbl.text = "Delivery"
            case .dineIn:
                self.nameLbl.text = "Dine In"
            case .takeout:
                self.nameLbl.text = "Take Out"
            case .viewAll:
                self.isSelected = true
                self.nameLbl.text = "View All"
            }
            setActive()
        }
    }
    
    //MARK: Helper Methods
    func setActive() {
        guard let service = service else {return}
        if self.isSelected {
            self.setBorders(color: .black)
            self.imageView.image = UIImage(named: "\(service.rawValue)Filled")!
        } else {
            self.setBorders(color: .clear)
            self.imageView.image = UIImage(named: service.rawValue)!
        }
    }
}
