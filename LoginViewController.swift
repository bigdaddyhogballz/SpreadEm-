//
//  LoginViewController.swift
//  tabbedBettingAPP
//
//  Created by john graybll on 2/20/17.
//  Copyright © 2017 john graybll. All rights reserved.
//
/* this class is to store off predictions for that are pulled form the SQL Table
 These predictions are pulled for a specific user later on in this code
 Their primary purpose is for the statistics in the statistics view controller
 and to color the game boxes accordingly in TableViewController.swift
 */
class prediction {
    var iD: AnyObject// unique ID of the prediction
    var userId: AnyObject //userId of the preduction
    var gameId: AnyObject // gameId of the prediction
    var score: AnyObject// score of the prediction if it was scored
    var scored: AnyObject // 0 if not scored 1 if scored
    var guess: AnyObject // the prediction on the line made by the user
    
    //takes in a dictionary of string/anyobject and converts them to the fields
    init(dict: Dictionary<String,AnyObject>)
    {
        iD = dict["ID"]!
        userId = dict["userId"]!
        gameId = dict["gameId"]!
        score = dict["score"]!
        scored = dict["scored"]!
        guess = dict["guess"]!
    }
    
    // class definition goes here
}

import UIKit
/*This is the view controller for the login page, it is the first page presented when opening the application, logging out also brings you back to here
 */
class LoginViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField! // the username user enters
    @IBOutlet weak var userPassword: UITextField! //the password user enters
    
    /* the primary purpose of the following variables is to get information that is needed in the other viewcontrollers upon loading */
    
    var myGames:[game] = [] // an array of games that is pulled when the user opens the app
    var myScores:[score] = [] // an array of scores of the leaderboards that is pulled when the user opens the app
    var userInfo:[user] = [] // an array to store the logged in users information it is userInfo[0]
    var predictions:[prediction] = [] // an array to store predictions that have been made by the logged in user
    var year = ""; // a string representation of the year set later
    var day = ""; // a string representation of day set later
    var month = ""; // a string representation of month set later
    
    override func viewDidLoad() {
        super.viewDidLoad()// super classes load
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!) // sets background
        
        /*
         The following code and many things resembling it are based upon code that allows you to pull or push information to a SQL table using JSON and PHP.  Their origins can be found on a website called http://codewithchris.com/iphone-app-connect-to-mysql-database/
         This particular block of code gets all of todays games and stores them in the games array, then calls the getLeaderboards() function which sets the scores in myScores.  This is all done upon loading of the login view controller because who is logging in is irrelevant to the games of the day and the top 10 users on the leaderboards
         */
        let myUrl = "http://127.0.0.1/vegasAppWeb/api/getTodaysGames.php" // script to pull todays games
        
        let requestURL = NSURL(string: myUrl)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        //temporary hardcode of date to pull the games from (Date is required in yyyy-mm-dd to get games)
        
        //A block of code to get todays date and passthe information to the application
        
        let date = Date()
        _ = Calendar.current
        
        
        //a bunch of substrings of the original date function
        let date3 = date.description
        let subIndex = date3.index(date3.startIndex,offsetBy: 10)
        let date4 =  date3.substring(to: subIndex)
        
        let subIndex1 = date3.index(date3.startIndex,offsetBy:4)
        var yearString = date3.substring(to: subIndex1)
        
        
        let subIndex2 = date3.index(date3.startIndex,offsetBy:5)
        var dayStringTemp = date3.substring(from: subIndex2)
        let subIndex3 = dayStringTemp.index(dayStringTemp.startIndex,offsetBy:2)
        let monthString = dayStringTemp.substring(to: subIndex3)
        
        let subIndex4 = date3.index(date3.startIndex,offsetBy:8)
        var monthStringTemp = date3.substring(from: subIndex4)
        let subIndex5 = dayStringTemp.index(monthStringTemp.startIndex,offsetBy:2)
        let dayString = monthStringTemp.substring(to: subIndex5)
        
        // sets the strings so that the date can be passed to another viewcontroller
        year = yearString
        month = monthString
        day = dayString
        
        
        // print(date4) // double checking the date
        //creating the post parameter by concatenating the keys and values from text field
        //        let parameters = ["date": date!] as Dictionary<String, String>
        
        let postParameters = "date="+date4;
        
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
                    
                    // a variable to cut off the last 2 fields added to the dictionary,these two are for testing purposes but not neccesary
                    if(parseJSON.count>2)
                    {
                        let num = parseJSON.count-3
                        
                        
                        let index = 0 // temp number for loop
                        for index in 0...num// a loop to go from the first obj to the last important obj that adds games to the games array
                        {
                            var a = parseJSON.object(forKey: String(index)) as! Dictionary<String, AnyObject>
                            var agame = game(dict: a )
                            self.myGames.append(agame)
                        }
                        
                    }
                    else
                    {
                        
                    }
                    
                    
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        //calls the getLeaderBoards() function which adds the scores to the scores array so that we have all games and scores as soon as the user opens the app
        getLeaderboards()
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    //Inhereted from super
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     This is again code like above borrowed from the website stated previously but used to call a different script called getTopScores.php which gets the top users and their scores which are displayed in the leaderboards tab.
     */
    func getLeaderboards()
    {
        let myUrl = "http://127.0.0.1/vegasAppWeb/api/getTopScores.php" // the script to get the scores of the top 10 leaders
        
        let requestURL = NSURL(string: myUrl)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        
        
        
        
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
                
                
                
                // essentially the sameas the loop above only it sets scores instead of games
                if let parseJSON = myJSON {
                    let num = parseJSON.count-3
                    
                    let index = 0
                    for index in 0...num
                    {
                        var a = parseJSON.object(forKey: String(index)) as! Dictionary<String, AnyObject>
                        var ascore = score(dict: a as! Dictionary<String, AnyObject>)
                        self.myScores.append(ascore)
                    }
                    
                    
                    
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
    }
    /*Simialar to the functions to get games and scores, this function fills the predictions array by calling the getUserPredictions.php script.  This function is actually called once the user has succesfully logged in.  So in addition to filling the array it also passes all of the variables needed to the other view controllers and displays the FirstViewController as well as the tab bar.
     */
    func getPredictions(iD: String)
    {
        
        let myUrl = "http://127.0.0.1/vegasAppWeb/api/getUserPredictions.php" // the script to get the scores of the top 10 leaders
        
        let requestURL = NSURL(string: myUrl)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        let postParameters = "id="+iD;
        
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
                
                
                
                // essentially the sameas the loop above only it sets scores instead of games
                if let parseJSON = myJSON {
                    let num = parseJSON.count-3
                    if(num>0)
                    {
                        let index = 0
                        for index in 0...num
                        {
                            var a = parseJSON.object(forKey: String(index)) as! Dictionary<String, AnyObject>
                            var aPrediction = prediction(dict: a as! Dictionary<String, AnyObject>)
                            self.predictions.append(aPrediction)
                        }
                        
                        
                    }
                }
                /*This set of code gets all 3 of the tabs from the tab bar controller as children. Then assigns them each the variables neccesary for their respectiveViewDidLoad() functions
                 */
                let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "first") as! UITabBarController
                var destinationViewController = tabBarController.viewControllers?[0] as! FirstViewController //sets child 0 to firstViewController(Predictions)
                destinationViewController.userInfo = self.userInfo// passes the user
                destinationViewController.myGames = self.myGames// passes games for the day
                destinationViewController.myScores = self.myScores//passes the scores and names for leaderboards
                destinationViewController.predictions = self.predictions//passes the array of users predictions
                destinationViewController.year = self.year// passes the year
                destinationViewController.month = self.month//month
                destinationViewController.day = self.day// day
                
                var destinationViewController2 = tabBarController.viewControllers?[2] as! LeaderBoardsView //sets child 2 to LeaderBoardsView
                destinationViewController2.myScores = self.myScores// passes the score array
                destinationViewController2.userInfo = self.userInfo// passes the user info
                var destinationViewController3 = tabBarController.viewControllers?[1] as! StatisticsViewController //sets child 2 to StatisticsViewController
                destinationViewController3.userInfo = self.userInfo// passes the user
                destinationViewController3.predictions = self.predictions// passes predictions array
                
                //code to let the viewcontroller finish up any lagging processes before changing screens
                OperationQueue.main.addOperation{
                    self.present(tabBarController, animated: true, completion: nil)//presents the tab bar controller which actually presents FirstViewController
                }
                
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }
    /*
     A function to get the users info through the php scrip getUserId.php and sets it to the userInfo array, then calls the getPredictions() function when passing in the correct ID gotten from user. This is all called in a chain reaction upon succesful login on the submit() function
     */
    func getUserInfo(name: String)
    {
        let myUrl = "http://127.0.0.1/vegasAppWeb/api/getUserId.php" //pulls user info
        
        let requestURL = NSURL(string: myUrl)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        let postParameters = "name="+name;
        
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
                
                
                
                // essentially the sameas the loop above only it sets scores instead of games
                if let parseJSON = myJSON {
                    let num = parseJSON.count-3
                    self.userInfo.removeAll()
                    
                    let index = 0
                    for index in 0...num
                    {
                        var a = parseJSON.object(forKey: String(0)) as! Dictionary<String, AnyObject>
                        var info = user(dict: a as! Dictionary<String, AnyObject>)
                        print(info.password)
                        self.userInfo.append(info)
                    }
                    print(self.userInfo.count)
                    let pred = self.userInfo[0].iD as! String
                    self.getPredictions(iD: pred)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        
        
        task.resume()
        
    }
    //an function to display alert messages, for some reason has been causing crashes when called amongst functions that connect through PHP.  This function may be changed during later use
    func displayMyAlertMessage(userMessage: String)
    {
        
        //  a message that appears if the user messes up the login
        var myAlert = UIAlertController(title:"Alert",message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok",style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true,completion:nil)
    }
    
    
    /*what to do when the user hits the login button, it checks to make sure there is a correct login then calls the getUserInfo() function which calls the getPredictions() function which presents the actual application as the tab bar view unless the user messes up the login in which case nothing happens and the user must try again or go register
     */
    @IBAction func loginButtonTapped(_ sender: Any)
    {
        
        let uEmail = userEmail?.text // gets the username from the field entered
        let uPassword = userPassword?.text //gets the password from the field entered
        
        
        //checks to see if they left a field blank, if so dont let them in
        if ((uPassword?.isEmpty)! || (uEmail?.isEmpty)!)
        {
            return
        }
        
        UserDefaults.standard.set(uEmail, forKey: "userName")// store the username if they entered something in both fields
        UserDefaults.standard.synchronize();
        
        let myUrl = "http://127.0.0.1/vegasAppWeb/api/login.php"//the script to verify if their password and username are correct
        
        let requestURL = NSURL(string: myUrl)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        let userName=uEmail
        let userPass = uPassword
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "name="+userName!+"&password="+userPass!;
        
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
                    
                    //creating a string
                    var msg : String!
                    
                    var resultValue:String = parseJSON["status"] as! String!;
                    print("result:\(resultValue)")
                    //checks to see if they logged in correctly
                    if(resultValue=="Success")
                    {
                        
                        UserDefaults.standard.set(true, forKey: "isUserLogin")
                        UserDefaults.standard.synchronize();
                        self.getUserInfo(name: uEmail!)
                        
                        
                    }
                        //not working right now but i would like to display a error message in the future
                    else
                    {
                        //                        self.displayMyAlertMessage(userMessage: "Your login attemp was unsuccessful, please try again")
                    }
                    
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }
    
    
}
