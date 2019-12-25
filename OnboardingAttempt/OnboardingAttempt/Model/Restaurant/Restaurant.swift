//
//  Restaurant.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

struct Restaurant: Searchable, Codable {
    //var image: UIImage
    #warning("use raw values for categoryType and serviceTypes")
    var categoryType: String = CategoryType.restaurant.rawValue //would use CategoryType for safety, but need to research encoding custom types
    var serviceTypes: [String] //would use ServiceType for safety, but need to research encoding custom types
    var name: String
    var imageData: Data
}
