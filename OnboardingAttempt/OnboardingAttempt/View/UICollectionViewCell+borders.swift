//
//  UICollectionViewCell+borders.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/24/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    func setBorders(color: UIColor, width: CGFloat = 2, cornerRadius: CGFloat = 8) {
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
}
