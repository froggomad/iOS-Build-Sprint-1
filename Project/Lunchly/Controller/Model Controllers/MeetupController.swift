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
            if Date() >= voteEnds {
                print(meetup.userVotes)
                //userVotes has the username as Key and restaurant they voted on as Value.
                for (_ , restaurant) in meetup.userVotes {
                    if restaurantVotes[restaurant] != nil {
                        restaurantVotes[restaurant]! += 1 //add 1 to the restaurant's current votes
                    } else {
                        restaurantVotes[restaurant] = 1 //the restaurant doesn't have votes yet, give it 1
                    }
                }
                let duplicateVotes = getduplicateVotes(restaurantVoteDict: restaurantVotes)
                print("Duplicate Votes: \(duplicateVotes)")
                
                let sortedKeys = restaurantVotes.keys.sorted{restaurantVotes[$0]! > restaurantVotes[$1]!}
                if let firstKey = sortedKeys.first {
                    //check for random vote
                    var mutatedMeetup = meetup
                    mutatedMeetup.restaurant = firstKey
                    updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: mutatedMeetup)
                }
            } else {
                print("It's not time to tally until the vote ends at \(voteEnds)")
            }
        }
    }
    
    //MARK: Helper Methods
    private func getduplicateVotes(restaurantVoteDict: [Restaurant:Int]) -> [Restaurant:Int]? {
        var uniqueValues = [Restaurant:Int]()
        var duplicateValues: [Restaurant:Int]?
        for (key,value) in restaurantVoteDict {
            //stores the first time the value appears
            if !uniqueValues.contains(where:value) {
            uniqueValues.append(key)
            //stores the next time the value appears
          } else {
            if duplicateValues == nil {
                duplicateValues = [Restaurant]()
            }
            if !duplicateValues!.contains(key) {
                duplicateValues!.append(key)
            }
          }
        }
        return duplicateValues
    }

    private func randomVote(restaurantVoteDict: [Restaurant:Int]) -> Restaurant? {
        if let duplicateVotesArray = getduplicateVotes(restaurantVoteDict: restaurantVoteDict) {
            if duplicateVotesArray.count > 0 {
                let randomNumber = Int.random(in: 0..<duplicateVotesArray.count)
                return duplicateVotesArray[randomNumber]
            }
        }
        return nil
    }
    
}
