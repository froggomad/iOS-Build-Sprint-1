//
//  Alert.swift
//  Lunchly
//
//  Created by Kenny on 12/30/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//
//commit
import UIKit

class Alert {
    class func show(title: String, message: String, vc: UIViewController, complete: @escaping () -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        vc.present(alert, animated: true) {
            complete()
        }
    }
    
    class func inputForMeetupNotification(title: String, message: String, vc: UIViewController, complete: @escaping (_ result: Int, _ status: Bool) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Leave how many minutes before?"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Schedule", style: .default, handler: { [weak alert] (_) in
            if let text = alert?.textFields?[0].text {
                guard let minutes = Int(text) else {
                    complete(0, false)
                    return
                }
                complete(minutes, true)
            }
        }))
        vc.present(alert, animated: true)
    }
}
