//
//  Meetup.swift
//  Lunchly
//
//  Created by Kenny on 12/31/19.
//  Copyright © 2019 Hazy Studios. All rights reserved.
//

import Foundation

struct Meetup: Codable, Equatable {
    let id: String //for tracking notifications, comparing meetups for updating
    var name: String
    var possibleRestaurants: [Restaurant]
    var restaurant: Restaurant?
    var location: String?
    var voteEnds: Date?
    var meetupStarts: Date
    var userVotes: [Vote]?
    private var restaurantVotes: [Restaurant:Int] = [:]
    
    
    init(id: String, name: String, meetupStarts: Date, possibleRestaurants: [Restaurant]) {
        self.id = id
        self.name = name
        self.meetupStarts = meetupStarts
        self.possibleRestaurants = possibleRestaurants
        //set the meetup's restaurant if only one was chosen for the meetup
        if possibleRestaurants.count == 1 {
            self.restaurant = possibleRestaurants[0]
        }
        voteEnds = Date(timeInterval: -1800, since: meetupStarts)
    }
    
}
