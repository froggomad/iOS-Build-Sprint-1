//
//  Meetup.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation

struct Meetup: Codable, Equatable {
    let id: String //for tracking notifications
    var name: String
    var location: String?
    var meetupStarts: Date? {
        didSet {
            voteEnds = Date(timeInterval: -1800, since: meetupStarts!)
        }
    }
    var voteEnds: Date? = Date()
    
}
