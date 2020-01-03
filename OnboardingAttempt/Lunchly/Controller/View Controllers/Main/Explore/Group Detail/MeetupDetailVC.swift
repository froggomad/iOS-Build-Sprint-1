//
//  MeetupDetailVC.swift
//  Lunchly
//
//  Created by Kenny on 1/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MeetupDetailVC: UIViewController, UpdatesMeetup {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var meetup: Meetup?
    var meetupController: MeetupController?
    var restaurantVotes: [Restaurant:Int] = [:]
    var user: User?
    var group: Group?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        tableView.delegate = self
        tableView.dataSource = self
        tallyVotes()
        // Do any additional setup after loading the view.
    }
    

    func updateViews() {
        guard let meetup = meetup else {return}
        nameLabel.text = meetup.name
        dateLabel.text = formatDate(isTime: false)
        timeLabel.text = formatDate(isTime: true)
    }
    
    func formatDate(isTime: Bool) -> String {
        guard let meetup = meetup else {return "Date Not Set"}
        let dateFormatter = DateFormatter()
        if isTime {
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
        } else {
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
        }
        return dateFormatter.string(from: meetup.meetupStarts)
    }
    
    func updateRestaurantSelection(restaurant: Restaurant) {
        guard let meetup = meetup,
              let group = group else {return}
        self.meetup!.userVotes[user?.name ?? "none"] = restaurant
        meetupController?.updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: self.meetup!)
        //update meetup (use meetupController)
        //update group (use delegate)
        //saveToPersistentStore (use meetupController -> delegate)
        #warning("move this call")
        tallyVotes()
    }
    
    //fire after meetup.voteEnds
    func tallyVotes() {
        guard let meetup = meetup,
            let voteEnds = meetup.voteEnds
        else {return}
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
                self.meetup?.restaurant = firstKey
                guard let group = group else {return}
                meetupController?.updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: self.meetup!)
            }
            //for user in group, notify them that the vote ended, ask if they'd like to set a reminder for a time to leave (implement notification switch)
        }
    }
}

extension MeetupDetailVC: UITableViewDelegate {
    
}

extension MeetupDetailVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.meetup?.possibleRestaurants.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "VoteOnRestaurantCell") as? VoteRestaurantCell else {return UITableViewCell()}
        cell.restaurant = meetup?.possibleRestaurants[indexPath.row]
        cell.delegate = self
        cell.backgroundColor = .clear
        cell.wasVotedOnOutlet.setTitleColor(.label, for: .normal)
        if let meetupRestaurant = meetup?.restaurant {
            if cell.restaurant == meetupRestaurant {
                cell.backgroundColor = UIColor(named: "Secondary")
                cell.wasVotedOnOutlet.setImage(nil, for: .normal)
                cell.wasVotedOnOutlet.setTitle("Winner!", for: .normal)
                cell.wasVotedOnOutlet.isEnabled = false
            }
        }
        return cell
    }
    
    
}
