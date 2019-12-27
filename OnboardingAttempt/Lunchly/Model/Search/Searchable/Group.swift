//
//  Group.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

struct Group: Searchable, Codable, Equatable {
    var categoryType: CategoryType = .group
    var name: String
    var imageData: Data
    var serviceTypes: [ServiceType]
    var users: [User] = []
    var restaurants: [Restaurant] = []
}
