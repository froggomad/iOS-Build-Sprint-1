//
//  MeetupDetailVC.swift
//  Lunchly
//
//  Created by Kenny on 1/2/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MeetupDetailVC: UIViewController, UpdatesMeetup {
    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    //MARK: Class Properties
    weak var delegate: GroupDetailVC?
    var meetup: Meetup?
    var meetupController: MeetupController?
    var restaurantVotes: [Restaurant:Int] = [:]
    var user: User?
    var group: Group?
    
    //MARK: View Lifecycle (Update View)
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let group = group,
              let meetup = meetup
        else {return}
        meetupController?.tallyVotes(group: group, meetup: meetup)
    }
    
    //MARK: Helper Methods
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
        let restaurantDict = ["restaurant":restaurant]
        print(restaurantDict)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "changeSwitch"), object: nil, userInfo: restaurantDict)
        guard let meetup = meetup,
              let group = group else {return}
        self.meetup!.userVotes[user?.name ?? "coffeLvr2001"] = restaurant
        meetupController?.updateMeetup(group: group, originalMeetup: meetup, mutatedMeetup: self.meetup!)
        for (index,groupMeetup) in group.meetups.enumerated() {
            if meetup.id == groupMeetup.id {
                self.group!.meetups[index] = self.meetup!
            }
        }
        delegate?.updateGroup(group: self.group!)
    }

}

extension MeetupDetailVC: UITableViewDelegate {
    
}
//MARK: TableView DataSource
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
        if let userVotes = meetup?.userVotes {
            if let userVote = userVotes[user?.name ?? "fred"] {
                print("\(user?.name ?? "fred") voted on \(userVote.name)")
                if cell.restaurant == userVote {
                    cell.wasVotedOnOutlet.setImage(UIImage(systemName: "rectangle.fill.badge.checkmark"), for: .normal)
                    cell.wasVotedOnOutlet.setTitle("", for: .normal)
                }
            }
        }
        
        if let meetupRestaurant = meetup?.restaurant {
            cell.wasVotedOnOutlet.setImage(nil, for: .normal)
            cell.wasVotedOnOutlet.isEnabled = false
            if cell.restaurant == meetupRestaurant {
                cell.backgroundColor = UIColor(named: "Secondary")
                cell.wasVotedOnOutlet.setTitle("Winner!", for: .normal)
            } else {
                cell.wasVotedOnOutlet.setTitle("", for: .normal)
            }
        }
        return cell
    }
    
    
}
