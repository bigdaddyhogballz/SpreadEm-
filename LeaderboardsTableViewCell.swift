//
//  LeaderboardsTableViewCell.swift
//  TableCell
//
//  Created by john graybll on 4/24/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

class LeaderboardsTableViewCell: UITableViewCell {

    @IBOutlet var UserName: UILabel!  // a label for the username of each of the leaders
    @IBOutlet var Score: UILabel!  // a label for the score of each of the leaders
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
