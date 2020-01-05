//
//  Vote.swift
//  Lunchly
//
//  Created by Kenny on 1/5/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import Foundation

struct Vote: Codable, Equatable {
    var restaurant: Restaurant
    var votes: Int
}
