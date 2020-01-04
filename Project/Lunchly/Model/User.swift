//
//  User.swift
//  Lunchly
//
//  Created by Kenny on 12/26/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation
struct User: Codable, Equatable {
    var name: String
    var image: Data
    var groups: [Group]
    var restaurants: [Restaurant]
}
