//
//  ScoringHelpView.swift
//  TableCell
//
//  Created by john graybll on 5/14/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

/* just a simple view controller to give the User some understanding on how scoring works in the application, it contains info only to send it back
 */


class ScoringHelpView: UIViewController {
    var myGames:[game] = [] // array of games
    var predictions:[prediction] = [] // array of predictions
    var userInfo:[user] = [] // the user info
    var myScores:[score] = [] // leaderboards info
    
    //sets bg color
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!)
         super.viewDidLoad()
    }
    

    //passes all the data back to the firstViewController and TabBar
    @IBAction func back(_ sender: Any) {
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "first") as! UITabBarController
        var destinationViewController = tabBarController.viewControllers?[0] as! FirstViewController // or whatever tab index you're trying to access
        destinationViewController.userInfo = self.userInfo
        destinationViewController.myGames = self.myGames
        destinationViewController.myScores = self.myScores
        destinationViewController.predictions = self.predictions
        
        var destinationViewController2 = tabBarController.viewControllers?[2] as! LeaderBoardsView // or whatever tab index you're trying to access
        destinationViewController2.myScores = self.myScores
        destinationViewController2.userInfo = self.userInfo
        var destinationViewController3 = tabBarController.viewControllers?[1] as! StatisticsViewController // or whatever tab index you're trying to access
        destinationViewController3.userInfo = self.userInfo
        destinationViewController3.predictions = self.predictions
        OperationQueue.main.addOperation{
            self.present(tabBarController, animated: true, completion: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
