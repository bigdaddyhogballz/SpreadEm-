//
//  StatisticsViewController.swift
//  TableCell
//
//  Created by john graybll on 5/1/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit
/* a class for the user which is passed back and forth between view controllers so that score and username can be displayed on each page
 */
class user {
    var iD: AnyObject// unique ID of the game
    var name: AnyObject //line of the game
    var password: AnyObject // result of the game
    var score: AnyObject// time the game is supposed to be
    var num_predictions: AnyObject // home team
    var scored_predictions: AnyObject // away team
    var better_predictions: AnyObject // away team
    
    //takes in a dictionary of string/anyobject and converts them to the fields
    init(dict: Dictionary<String,AnyObject>)
    {
        iD = dict["id"]!
        name = dict["name"]!
        password = dict["password"]!
        score = dict["score"]!
        num_predictions = dict["num_predictions"]!
        scored_predictions = dict["scored_predictions"]!
        better_predictions = dict["better_predictions"]!
    }
    
    // class definition goes here
}
/*
 The view controller for the statistics page
 */
class StatisticsViewController: UIViewController {
    var userInfo:[user] = [] // the array which contains this user at [0]
    var predictions:[prediction] = [] // the array of predictions this user has made
    
    //the following labels are displayed on the screen and are modified based on the data passed to this viewcontroller
    @IBOutlet var aScore: UILabel!
    
    @IBOutlet var uName: UILabel!
    
    @IBOutlet var uScore: UILabel!
    
    @IBOutlet var uPred: UILabel!
    
    @IBOutlet var sPred: UILabel!
    
    @IBOutlet var bPred: UILabel!
    
    @IBOutlet var Accuracy: UILabel!
    
    /*
     This function sets all of the labels displayed based on the information passed which is all of this users information.  Also calls the two functions countScoredPredictions() and countBetterPredictions
 */
    override func viewDidLoad() {
        let countP = predictions.count // the total prediction the user has made
        let countS = countScoredPredictions() // the number of predictions the user has made that have been scored
        let countB = countBetterPredictions() // the number of predictions that are over 100 points that have been scored, ie better than the vegas line
        print(countP)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!) // sets bg color for app
        self.uName.text = userInfo[0].name as! String // sets username
        self.uScore.text = userInfo[0].score as! String // sets score
        //if there are predictions then set these labels
        if(predictions.count>0)
        {
            let average = ((userInfo[0].score as! NSString).doubleValue)/countS
            self.aScore.text = String(average)
        self.uPred.text = String(countP)
        self.sPred.text = String(countS)
        self.bPred.text = String(countB)
        self.Accuracy.text = String((countB/countS)*100)+"%"
        }
         //if not just set them to the values pulled from the SQL table which are 0
        else
        {
            self.uPred.text = userInfo[0].num_predictions as! String
            self.sPred.text = userInfo[0].scored_predictions as! String
            self.bPred.text = userInfo[0].better_predictions as! String
        }

        
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    // a function which loops through predictions and if they have been scored adds 1 to the value and returns the total
    func countScoredPredictions() -> Double
    {
        var count = 0.0 // temp value to return
       
        for i in predictions
        {
            let a = (i.scored as! NSString).doubleValue
            if(a==1) // checks if scored is 1
            {
                count += 1 // increments
            }
        }
        return count //returns total
    }
    // a function which does the same thing as above but only increments if the score is over 100
    func countBetterPredictions()-> Double    {
        var count = 0.0 // temp return value
        for i in predictions
        {
            let a = (i.scored as! NSString).doubleValue
            if(a==1)// if scored is 1
            {
                let b = (i.score as! NSString).doubleValue
                if(b>100) // if the score is over 100
                {
                    count += 1 //increment
                }
            }
            
        }
        return count //return total
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 

}
