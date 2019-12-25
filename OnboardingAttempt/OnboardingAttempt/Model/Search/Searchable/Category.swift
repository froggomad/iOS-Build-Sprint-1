//
//  Category.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import UIKit

struct Category {
    var categoryType: String = CategoryType.category.rawValue
    var name: String
    var imageData: Data
    var service: String
}
