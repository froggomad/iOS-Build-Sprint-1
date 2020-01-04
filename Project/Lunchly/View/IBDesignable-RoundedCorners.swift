//
//  IBDesignable-RoundedCorners.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/22/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
