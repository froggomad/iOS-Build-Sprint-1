//
//  UIButton+titlePadding.swift
//  Lunchly
//
//  Created by Kenny on 1/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

extension UIButton {
    func titlePadding(left: CGFloat = 8, right: CGFloat = 8, bottom: CGFloat = 0, top: CGFloat = 0) {
        self.titleEdgeInsets = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        
        let widthConstraint = NSLayoutConstraint (item: self, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.width + left + right)
        self.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint (item: self, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: self.frame.height + top + bottom)
        self.addConstraint(heightConstraint)
    }
}
