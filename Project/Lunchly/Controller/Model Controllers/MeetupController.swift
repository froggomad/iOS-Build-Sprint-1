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
        //holds the number of votes each restaurant has
        var restaurantVotes: [Restaurant:Int] = [:]
        for meetup in group.meetups {
            guard let voteEnds = meetup.voteEnds else {return}
            //check if the vote has ended
            //MARK: Testing
            #warning("uncomment below after testing")
//            if Date() >= voteEnds {
//                print(meetup.userVotes)
//                //userVotes has the username as Key and restaurant they voted on as Value.
//                for (_ , restaurant) in meetup.userVotes {
//                    if restaurantVotes[restaurant] != nil {
//                        restaurantVotes[restaurant]! += 1 //add 1 to the restaurant's current votes
//                    } else {
//                        restaurantVotes[restaurant] = 1 //the restaurant doesn't have votes yet, give it 1
//                    }
//                }
            //Test Clear Winner
            restaurantVotes = [
                Restaurant(name: "Rest1", imageData: Data(), address: "", serviceTypes: [.dineIn]):3,
                Restaurant(name: "Rest2", imageData: Data(), address: "", serviceTypes: [.dineIn]):3,
                Restaurant(name: "Rest3", imageData: Data(), address: "", serviceTypes: [.dineIn]):1
            ]
                var votes = [Vote]()
                for (key, value) in restaurantVotes {
                    votes.append(Vote(restaurant: key, votes: value))
                }
                
                let sortedVotes = votes.sorted(by: {$0.votes > $1.votes})
                print(sortedVotes)
                var mutatedMeetup = meetup
                if sortedVotes[0].votes > sortedVotes[1].votes {
                    mutatedMeetup.restaurant = sortedVotes[0].restaurant
                    updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                    print("\(sortedVotes[0].restaurant.name) is clearly the winner!")
                } else {
                    if let duplicateVotes = getDuplicateWinningVotes(sortedRestaurantVotes: sortedVotes) {
                        mutatedMeetup.restaurant = randomVote(duplicateRestaurants: duplicateVotes)
                        updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                        print("There was a tie between \(duplicateVotes)")
                        print("The winner is \(mutatedMeetup.restaurant?.name)")
                    }
                }
                
//            } else {
//                print("It's not time to tally until the vote ends at \(voteEnds)")
//            }
        }
    }
    
    //MARK: Helper Methods
    private func getDuplicateWinningVotes(sortedRestaurantVotes: [Vote]) -> [Restaurant]? {
        let highValue = sortedRestaurantVotes[0].votes
        var highVotes = [Restaurant]()
        for vote in sortedRestaurantVotes {
            if vote.votes == highValue {
                highVotes.append(vote.restaurant)
            }
        }
        if highVotes.count > 0 {return highVotes}
        return nil
    }

    private func randomVote(duplicateRestaurants: [Restaurant]) -> Restaurant? {
        if duplicateRestaurants.count >= 2 {
            let randomNumber = Int.random(in: 0..<duplicateRestaurants.count)
            return duplicateRestaurants[randomNumber]
        }
        return nil
    }
    
}
