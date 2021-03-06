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
    let notificationHandler = NotificationController()
    
    //MARK: Delegate Methods
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
            if Date() >= voteEnds && meetup.restaurant == nil { //found out the hard way that the restaurant could be set (ie only one was chosen) and this function would then make it nil
                
                //Construct restaurantVotes Dictionary using meetup.userVotes
                //userVotes has the username as Key and restaurant they voted on as Value.
                for (_ , restaurant) in meetup.userVotes {
                    if restaurantVotes[restaurant] != nil {
                        restaurantVotes[restaurant]! += 1 //add 1 to the restaurant's current votes
                    } else {
                        restaurantVotes[restaurant] = 1 //the restaurant doesn't have votes yet, give it 1
                    }
                }
                let sortedVotes = constructVotes(restaurantVotes: restaurantVotes) //returns [Vote] for easy sorting
                var mutatedMeetup = meetup
                
            //trigger vote
            if sortedVotes.count >= 2 {
                if sortedVotes[0].votes > sortedVotes[1].votes {
                    mutatedMeetup.restaurant = sortedVotes[0].restaurant
                    updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                    triggerVoteEndNotification(meetup: meetup)
                } else {
                    if let duplicateVotes = getDuplicateWinningVotes(sortedRestaurantVotes: sortedVotes) {
                        mutatedMeetup.restaurant = randomVote(duplicateRestaurants: duplicateVotes)
                        updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                        triggerVoteEndNotification(meetup: meetup)
                    }
                }
            } else {
                //assign restaurant
                let restaurantArray = meetup.possibleRestaurants
                if let randomRestaurant = randomVote(duplicateRestaurants: restaurantArray) {
                    mutatedMeetup.restaurant = randomRestaurant
                } else {
                    mutatedMeetup.restaurant = meetup.possibleRestaurants[0]
                }
                updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                triggerVoteEndNotification(meetup: meetup)
            }
            
            } else {
                print("It's not time to tally until the vote ends at \(voteEnds)")
            }
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
    
    private func constructVotes(restaurantVotes: [Restaurant:Int]) -> [Vote] {
        var votes = [Vote]()
        for (key, value) in restaurantVotes {
            votes.append(Vote(restaurant: key, votes: value))
        }
        
        return votes.sorted(by: {$0.votes > $1.votes})
    }
    
    private func triggerVoteEndNotification(meetup: Meetup) {
        notificationHandler.notificationRequest()
        notificationHandler.triggerNotification(meetup: meetup, notificationType: .votingEnded, onDate: Date(), withId: "\(meetup.id)-\(NotificationType.timeToLeave.rawValue)")
    }
}
