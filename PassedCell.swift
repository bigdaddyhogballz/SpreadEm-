//
//  PassedCell.swift
//  TableCell
//
//  Created by john graybll on 5/14/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

class PassedCell: UITableViewCell {

    @IBOutlet var homeLabel: UILabel! // label for home team
    @IBOutlet var awayLabel: UILabel! // label for away team
    @IBOutlet var actual: UILabel! // label for actual result
    @IBOutlet var time: UILabel! // label for time
    @IBOutlet var line: UILabel! // label for line
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
