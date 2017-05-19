//
//  tabBar.swift
//  TableCell
//
//  Created by john graybll on 3/30/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

class tabBar: UITabBarController {
    var myGames:[game] = [] // array of games this controller can be passed and then pass out to its children
    var myScores:[score] = []// array of scores this controller can be passed and then pass out to its children
    override func viewDidLoad() {
        
               

        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //what to do if segues are called, just passing the data (scores or games)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="gamesSegue")
        {
            print(self.myGames.count)
            
            if let DVC = segue.destination as? FirstViewController
            {
                DVC.myGames = self.myGames
            }
         
            
        }

        
        if (segue.identifier=="leaderboardsSegue")
        {
            
            if let DVC = segue.destination as? LeaderBoardsView
            {
                DVC.myScores   = self.myScores
            }
         
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
