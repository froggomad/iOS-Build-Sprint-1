//
//  UIColor+customColors.swift
//  Lunchly
//
//  Created by Kenny on 1/9/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

extension UIColor {
    class func primaryColor() -> UIColor {
        return UIColor(named: "Primary")!
    }
    
    class func secondaryColor() -> UIColor {
        return UIColor(named: "Secondary")!
    }
    
    class func actionColor() -> UIColor {
        return UIColor(named: "Action")!
    }
    
    class func secondaryActionColor() -> UIColor {
        return UIColor(named: "SecondaryAction")!
    }
}
