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
            guard let meetup = meetup, //redundant, could force unwrap meetup since it's been set when didSet is called, but force unwrapping would also technically be redundant, and I like to avoid force unwrapping
                  let meetupStarts = meetup.meetupStarts
            else {return}
            let timeDifference = Calendar.current.dateComponents([.minute], from: meetup.voteEnds ?? Date(), to: Date()).minute ?? 0
            self.nameLabel.text = meetup.location ?? "voting ends in \(timeDifference) minutes)"
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            let dateString = dateFormatter.string(from: meetupStarts)
            self.dateLabel.text = dateString
        }
    }
}
