//
//  ViewController.swift
//  TableCell
//
//  Created by john graybll on 4/24/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit
/* A class to hold scores for leaderboards
 */
class score {
    var name: AnyObject // username of leader
    var score: AnyObject // score of leader
    //initializes the class when passed a dictionary of string/anyobject
    init(dict: Dictionary<String,AnyObject>)
    {
        name = dict["name"]! //sets name
        score = dict["score"]! // sets score
    }
    
   
}
/* A class to display the username and score of each of the top 10 predictors, which passes this data to a custom table called LeaderboardsTableViewController
 */

class LeaderBoardsView: UIViewController {
    
    //the two labels displayed
    @IBOutlet var userNameLabel: UILabel!

    @IBOutlet var scoreLabel: UILabel!
    
    
    var myScores:[score] = [] // an array of scores passed to this viewcontroller
    var userInfo:[user] = [] // an array containing this users info
    
    
    //incase you want to do something special with logout
    @IBAction func logout(_ sender: Any)
    {
    }
    
    //sets the labels upon loading, the bg color
    override func viewDidLoad() {
        self.userNameLabel.text = self.userInfo[0].name as! String// sets username
        self.scoreLabel.text = self.userInfo[0].score as! String // sets score
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!)// sets bg color
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
//inhereted
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //send the scores over to the custom table to display the actual leaderboards
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier=="leaderboardsSegue")
        {
            
            if let DVC = segue.destination as? LeaderboardsTableViewController
            {
                DVC.myScores = self.myScores
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
