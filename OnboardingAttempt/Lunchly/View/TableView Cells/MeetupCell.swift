//
//  MeetupCell.swift
//  Lunchly
//
//  Created by Kenny on 1/1/20.
//  Copyright © 2020 Hazy Studios. All rights reserved.
//

import UIKit

class MeetupCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var meetup: Meetup? {
        didSet {
            guard let meetup = meetup else {return}
            let timeDifference = Calendar.current.dateComponents([.minute], from: Date(), to: meetup.voteEnds ?? Date()).minute ?? 0
            var votingString = ""
            if meetup.restaurant == nil {
                if timeDifference > 0 {
                    votingString = "Location TBD voting ends in \(timeDifference.timeDisplay())"
                } else {
                    votingString = "Voting ended \(timeDifference.timeDisplay()) ago. Please see the results!"
                }
            }
            self.nameLabel.text = meetup.restaurant?.name ?? votingString
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: meetup.meetupStarts)
            self.dateLabel.text = dateString
        }
    }
}
