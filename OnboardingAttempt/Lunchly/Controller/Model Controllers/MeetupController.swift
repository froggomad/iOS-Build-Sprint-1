//
//  MeetupController.swift
//  Lunchly
//
//  Created by Kenny on 1/1/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation

class MeetupController {
    //MARK: Class Properties
    weak var delegate: GroupController?
    var meetups: [Meetup] = []
    
    //MARK: Update
    func updateMeetup(group: Group, originalMeetup: Meetup, mutatedMeetup: Meetup) {
        print("updating meetup from MeetupController")
        delegate?.updateMeetup(group: group, originalMeetup: originalMeetup, amendedMeetup: mutatedMeetup)
    }
    
    //MARK: Class Methods
    func tallyVotes(group: Group, meetup: Meetup) {
        var restaurantVotes: [Restaurant:Int] = [:]
        for meetup in group.meetups {
            guard let voteEnds = meetup.voteEnds else {return}
            if Date() >= voteEnds {
                print(meetup.userVotes)
                for (_ , restaurant) in meetup.userVotes {
                    if restaurantVotes[restaurant] != nil {
                        restaurantVotes[restaurant]! += 1
                    } else {
                        restaurantVotes[restaurant] = 1
                    }
                }
                let sortedKeys = restaurantVotes.keys.sorted{restaurantVotes[$0]! > restaurantVotes[$1]!}
                if let firstKey = sortedKeys.first {
                    var mutatedMeetup = meetup
                    mutatedMeetup.restaurant = firstKey
                    updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                }
            } else {
                print("It's not time to tally until the vote ends at \(voteEnds)")
            }
        }

    }
    
}
