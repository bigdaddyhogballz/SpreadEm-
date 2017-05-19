//
//  predictionsViewController.swift
//  TableCell
//
//  Created by john graybll on 4/2/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit
//* the viewController for making a prediction
class predictionsViewController: UIViewController {
    @IBOutlet weak var sliderValue: UILabel! // the value of the prediction the user is setting
    @IBOutlet weak var homeLabel: UILabel! // the home team
    @IBOutlet weak var slider: UISlider! // how the user sets the prediction value
    @IBOutlet weak var awayLabel: UILabel! //the away team
    
    //changes the value displayed based on the slider location
    @IBAction func predictionSlider(_ sender: UISlider)
    {
        let currentValue = Int(sender.value)
        
        sliderValue.text = "\(currentValue)"
    }
    var myGames:[game] = [] // the array of games
    var predictions:[prediction] = [] // the array of predictions for this user
    var userInfo:[user] = [] // the users info stored at [0]
    var myScores:[score] = []// the leaderboards info
    
    var num:Int  = 0 // the location of the game in the games array that is being predicted upon
    
    //sets BG color and the values of the labels
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!)// set bg color
        
        
        // Do any additional setup after loading the view.
        
        
        //sets home and away labels
        homeLabel.text = myGames[num].home as! String
        awayLabel.text = myGames[num].away as! String
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //makes the prediction using the same PHP calling script
    @IBAction func submit(_ sender: Any) {
        
        let URL_REGISTER = "http://127.0.0.1/vegasAppWeb/api/userPredict.php"
        let guess = sliderValue.text!
        let userId = userInfo[0].iD as! String
        let gameId = myGames[num].iD as! String;
        let guessString = String(describing: guess)
        
        let requestURL = NSURL(string: URL_REGISTER)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "userId="+userId+"&gameId="+gameId+"&guess="+guessString;
        
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
                    
                    //getting the json response
                    msg = parseJSON["message"] as! String?
                    
                    //printing the response
                    print(msg)
                    
                }
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
        
        
    }
    // the same function from LoginViewController, pulls the new prediction data if tehre was any from the sql server then presents the Tab bar viewcontroller
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
                    self.predictions.removeAll()
                    let num = parseJSON.count-3
                    
                    let index = 0
                    if(num>0)
                    {
                        for index in 0...num
                        {
                            var a = parseJSON.object(forKey: String(index)) as! Dictionary<String, AnyObject>
                            var aPrediction = prediction(dict: a as! Dictionary<String, AnyObject>)
                            self.predictions.append(aPrediction)
                        }
                        
                        
                    }
                }
                
                /* the block of code that updates all the arrays for all the other view controller when we leave this screen
                 */
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
            } catch {
                print(error)
            }
            
        }
        //executing the task
        task.resume()
    }
    //updates variables on the predictions the user has made
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
    
    /*
     calls getUserInfo() which calls getPredictions() to update all of our arrays and send us back to the tab bar view
 */
    @IBAction func back(_ sender: Any)
    {
        getUserInfo(name: userInfo[0].name as! String)
        
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
