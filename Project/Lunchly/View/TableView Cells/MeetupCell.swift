//
//  MeetupCell.swift
//  Lunchly
//
//  Created by Kenny on 1/1/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MeetupCell: UITableViewCell {
    //MARK: IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    //MARK: Setup View
    var meetup: Meetup? {
        didSet {
            updateViews()
        }
    }
    
    //MARK: Helper Methods
    func updateViews() {
        guard let meetup = meetup else {return}
        //number of minutes until vote ends
        let timeDifference = Calendar.current.dateComponents([.minute], from: Date(), to: meetup.voteEnds ?? Date()).minute ?? 0
        var votingString = ""
        if meetup.restaurant == nil {
            if timeDifference > 0 {
                votingString = "TBD: voting ends in \(timeDifference.timeDisplay())"
            } else {
                votingString = "SEE RESULTS - Voting ended \(timeDifference.timeDisplay()) ago. Please see the results!" //during dev, voting was failing to update the tableView sometimes
            }
        }
        self.nameLabel.text = "\(meetup.name) at \(meetup.restaurant?.name ?? votingString)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: meetup.meetupStarts)
        self.dateLabel.text = dateString
    }
}
