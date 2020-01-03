//
//  Int+TimeDisplay.swift
//  Lunchly
//
//  Created by Kenny on 1/1/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//


/*
 Credit: https://stackoverflow.com/questions/26794703/swift-integer-conversion-to-hours-minutes-seconds#answer-58120815
 */
extension Int {
    func timeDisplay() -> String {
        if self > 0 {
            return "\(self / 3600) Day(s), \((self % 3600) / 60) hour(s), and \((self % 3600) % 60) minute(s)"
        }
            return "\(-self / 3600) Day(s), \((-self % 3600) / 60) hour(s), and \((-self % 3600) % 60) minute(s)"
    }
}
