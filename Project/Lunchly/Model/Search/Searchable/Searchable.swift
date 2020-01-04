//
//  Searchable.swift
//  OnboardingAttempt
//
//  Created by Kenny on 12/23/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//
import UIKit
protocol  Searchable {
    var categoryType: CategoryType {get}
    var name: String {get set}
    var imageData: Data {get set}
    var serviceTypes: [ServiceType] {get}
}
