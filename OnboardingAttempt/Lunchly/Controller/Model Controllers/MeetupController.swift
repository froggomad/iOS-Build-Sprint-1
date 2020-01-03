//
//  MeetupController.swift
//  Lunchly
//
//  Created by Kenny on 1/1/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//
import Foundation

class MeetupController {
    weak var delegate: GroupController?
    
    var meetups: [Meetup] = []
    
    //MARK: Update
    func updateMeetup(group: Group, originalMeetup: Meetup, mutatedMeetup: Meetup) {
        print("updating meetup from MeetupController")
        delegate?.updateMeetup(group: group, originalMeetup: originalMeetup, amendedMeetup: mutatedMeetup)
    }
    
    func voteHasEnded(group: Group, meetup: Meetup) -> Bool {
        guard let voteEnds = meetup.voteEnds else {return false}
        let voteEnded = voteEnds > Date()
        if voteEnded && meetup.restaurant == nil {
            #warning("use Restaurant from vote function")
            let randomRestaurant = Int.random(in: 0..<meetup.possibleRestaurants.count)
            for (index,thisMeetup) in group.meetups.enumerated() where meetup == thisMeetup {
                //meetups[index] = meetup
                meetups[index].restaurant = meetup.possibleRestaurants[randomRestaurant]
                delegate?.updateMeetup(group: group, originalMeetup: meetup, amendedMeetup: meetups[index])
            }
        }
        return voteEnded
    }
    
}
