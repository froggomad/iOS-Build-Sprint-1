//
//  Restaurant.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

struct Restaurant: Searchable, Equatable, Codable, Hashable {
    var categoryType: CategoryType = .restaurant
    var name: String
    var imageData: Data
    var address: String
    var serviceTypes: [ServiceType]
}
