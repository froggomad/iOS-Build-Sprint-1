//
//  UIViewController+endEditing.swift
//  Lunchly
//
//  Created by Kenny on 1/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import UIKit

/*
 Credit: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift#answer-49490207
 Purpose: dismiss keyboard in any viewcontroller when the view is tapped
*/

extension UIViewController {
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}
