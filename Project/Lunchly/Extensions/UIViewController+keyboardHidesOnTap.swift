//
//  UIViewController+endEditing.swift
//  Lunchly
//
//  Created by Kenny on 1/4/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import UIKit

/*
 Credit: https://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift?page=1&tab=active#tab-top#answer-27079103
 Purpose: dismiss keyboard in any viewcontroller when any view is tapped
*/

extension UIViewController {
    func keyboardHidesOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false //normally a tapGestureRecognizer will cancel touches and break things like didSelectRowAtIndexPath. This changes the default behavior
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
