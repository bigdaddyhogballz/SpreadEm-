//
//  PredictedCell.swift
//  TableCell
//
//  Created by john graybll on 5/13/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

class PredictedCell: UITableViewCell {

    @IBOutlet var homeLabel: UILabel! // label for home team
  
    @IBOutlet var awayLabel: UILabel! // label for away team
    
    @IBOutlet var guess: UILabel! // label for user guess
    
    @IBOutlet var line: UILabel! // label for vegas line
    
    @IBOutlet var time: UILabel! // label for time
}
