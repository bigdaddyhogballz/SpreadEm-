//
//  FirstViewController.swift
//  tabbedBettingAPP
//
//  Created by john graybll on 2/20/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

// a class called game to save all of the fields sent to the app for each game
class game {
    var iD: AnyObject// unique ID of the game
    var line: AnyObject //line of the game
    var actual: AnyObject // result of the game
    var time: AnyObject// time the game is supposed to be
    var home: AnyObject // home team
    var away: AnyObject // away team
    var completed: AnyObject
    var scored: AnyObject
    
    //takes in a dictionary of string/anyobject and converts them to the fields
    init(dict: Dictionary<String,AnyObject>)
    {
        iD = dict["ID"]!
        line = dict["Line"]!
        actual = dict["Actual"]!
        time = dict["Time"]!
        home = dict["Home"]!
        away = dict["Away"]!
        completed = dict["completed"]!
        scored = dict["scored"]!
    }
    
    // class definition goes here
}
/* the screen presented as the first part of tab bar controller once the user logs in, it displays all of todays games in the myGames array and will allow users to make predictions on those games.  The page actually contains a container view which is found on the Main.storyboard and it functions as a seperate page even though the information is displayed as if its on this page.  See TableViewController for the contents and workings of the rest of this page.
 */
class FirstViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel! // the label to display the user's username
    @IBOutlet weak var score: UILabel! // the label to display the user's score
    var userInfo:[user] = [] // an array containing the logged in user's info location[0]
    var myGames:[game] = [] // an array passed with all the vames
    var myScores:[score] = []// an array of the leaderboards info
    var predictions:[prediction] = []// an array of the predictions this user has made
    var year = "2017"//default values for year incase they are not passed, but this was for testing
    var day = "13"// above for day
    var month = "05"// above for month
    

    
    
    /*
     the function called upon loading this screen, sets the username and score labels
 */
    override func viewDidLoad()
    {
        score.text = userInfo[0].score as! String
        //supers did load
        super.viewDidLoad()
        
        // setst the background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!)
        //pulls username from default
        userName.text = UserDefaults.standard.string(forKey: "userName")
    }
    //inhereted function
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // trying to send the user back to the login if they got in without logging in correctly
    //not sure its neccesary or if its really working, basically you cant get here without logging in
    override func viewDidAppear(_ animated: Bool)
    {
        
        let isUserLoggedIn = UserDefaults.standard.bool(forKey: "isUserLogin")
        print(UserDefaults.standard.value(forKey: "userName"))
        
        
    }
    
    // sets the user to logged outand sends the user back to the login screen
    @IBAction func logoutButtonTapped(_ sender: Any)
    {
        UserDefaults.standard.set(false, forKey: "isUserLogin")
        UserDefaults.standard.synchronize()
        //self.userInfo.removeAll()
        self.performSegue(withIdentifier: "loginView", sender: self)
    }
    /* a function to move forward one day then what is displayed, this information is used to pull new games on the next day if there are any, in the case there is no new games the previous days are still shown.  It gets this information and directly passes it to the TableViewController. It does not work to change month
 */
    @IBAction func getNextDay(_ sender: Any)
    {
        
            day = String(Int(day)!+1)
            
            if(Int(day)!<10)
            {
                day.insert("0", at: day.startIndex)
            }
            
            
            
            let myUrl = "http://127.0.0.1/vegasAppWeb/api/getTodaysGames.php"
            
            let requestURL = NSURL(string: myUrl)
            
            let request = NSMutableURLRequest(url: requestURL! as URL)
            
            //setting the method to post
            request.httpMethod = "POST"
            
            
            
            let date = year+"-"+month+"-"+day
            
            print(date)
            //creating the post parameter by concatenating the keys and values from text field
            //        let parameters = ["date": date!] as Dictionary<String, String>
            
            let postParameters = "date="+date;
            
            //adding the parameters to request body
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
            
            
            //creating a task to send the post request
            let task = URLSession.shared.dataTask(with: request as URLRequest){
                data, response, error in
                
                if error != nil{
                    print("error is \(error)")
                    return;
                }
                
                //parsing the response
                do {
                    
                    //converting resonse to NSDictionary
                    let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    //parsing the json
                    
                    
                    
                    if let parseJSON = myJSON {
                        
                        let num = parseJSON.count-3
                        
                        
                        self.myGames.removeAll()
                        
                        let index = 0
                        if(parseJSON.count>2)
                        {
                            for index in 0...num
                            {
                                var a = parseJSON.object(forKey: String(index)) as! Dictionary<String, AnyObject>
                                var agame = game(dict: a as! Dictionary<String, AnyObject>)
                                self.myGames.append(agame)
                            }
                            let childView = self.childViewControllers.last as! TableViewController
                            childView.myGames = self.myGames
                            childView.updateGames(games: self.myGames)
                            
                            
                        }
                    }
                } catch {
                    print(error)
                }
                
            }
            //executing the task
            task.resume()
            
        

    }
    
    /* a function to move backward one day then what is displayed, this information is used to pull new games on the next day if there are any, in the case there is no new games the previous days are still shown.  It gets this information and directly passes it to the TableViewController. It does not work to change month.
     */
    @IBAction func getDayBefore(_ sender: Any) {
        //sets the day back one then calls the same get games method as in login view
        
        if(Int(day)!>1)
        {
        day = String(Int(day)!-1)
        }
        else{
            day = "1"
        }
        
        if(Int(day)!<10)
        {
            day.insert("0", at: day.startIndex)
        }
        
       
        
        let myUrl = "http://127.0.0.1/vegasAppWeb/api/getTodaysGames.php"
        
        let requestURL = NSURL(string: myUrl)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        
        
        let date = year+"-"+month+"-"+day
        
        print(date)
        //creating the post parameter by concatenating the keys and values from text field
        //        let parameters = ["date": date!] as Dictionary<String, String>
        
        let postParameters = "date="+date;
        
        //adding the parameters to request body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        
        //creating a task to send the post request
        let task = URLSession.shared.dataTask(with: request as URLRequest){
            data, response, error in
            
            if error != nil{
                print("error is \(error)")
                return;
            }
            
            //parsing the response
            do {
                
                //converting resonse to NSDictionary
                let myJSON =  try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                //parsing the json
                
                
                
                if let parseJSON = myJSON {
                    
                    let num = parseJSON.count-3
                    
                    
                    self.myGames.removeAll()
                    
                    let index = 0
                    if(parseJSON.count>2)
                    {
                    for index in 0...num
                    {
                        var a = parseJSON.object(forKey: String(index)) as! Dictionary<String, AnyObject>
                        var agame = game(dict: a as! Dictionary<String, AnyObject>)
                        self.myGames.append(agame)
                    }
                        print(self.myGames[0].home)
                        let childView = self.childViewControllers.last as! TableViewController
                        childView.myGames = self.myGames
                        childView.updateGames(games: self.myGames)
                    
                    
                    }
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
    }
    //if we want to do anything when the user clicks on Scoring Help besides show the screen
    @IBAction func scoringHelp(_ sender: Any)
    {
        
        
        
       
        
        
        
    }
    //passes the games to the table of games and the information on the variables to scoring help if its clicked so the data can be passed back
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if (segue.identifier=="gamesSegue")
        {
            print(self.myGames.count)
            
            if let DVC = segue.destination as? TableViewController
            {
                DVC.myGames = self.myGames
                DVC.predictions = self.predictions
                DVC.userInfo = self.userInfo
                DVC.myScores = self.myScores
            }
        }
        if (segue.identifier=="scoring")
        {
            
            if let DVC = segue.destination as? ScoringHelpView
            {
                DVC.myGames = myGames // passes all the games
                DVC.predictions = predictions
                DVC.userInfo = userInfo
                DVC.myScores = myScores
            }
        }
    }

    
    
    
    
}

