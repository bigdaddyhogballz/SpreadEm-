//
//  RegisterPageViewController.swift
//  tabbedBettingAPP
//
//  Created by john graybll on 2/20/17.
//  Copyright © 2017 john graybll. All rights reserved.
//

import UIKit

/* This class manages the registration page of the application that can be seen on Main.storyboard
 */
class RegisterPageViewController: UIViewController {
    
    @IBOutlet weak var userEmail: UITextField! // field for user to enter a username in the sign up process
    
    @IBOutlet weak var userPass: UITextField!// field for user to enter a password in the sign up process
    
    @IBOutlet weak var verify: UITextField! // field for user verify there password
    let URL_REGISTER = "http://127.0.0.1/vegasAppWeb/api/register.php" // the php script to register user
    
    
    override func viewDidLoad() {
        super.viewDidLoad() //superclass's viewdidload
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "homepage app.png")!)// sets the background of the page to the image in the folder titled homepage app.png
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //a function to display errors if they fail the login
    func displayMyAlertMessage(userMessage: String)
    {
        var myAlert = UIAlertController(title:"Alert",message:userMessage, preferredStyle:UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title:"Ok",style:UIAlertActionStyle.default, handler:nil);
        
        myAlert.addAction(okAction)
        self.present(myAlert,animated:true,completion:nil)
    }
    /*called when the user submits the request to register, if everything goes right it adds a new user to the SQL table users, and allows the new account to login with the created info, if not it displays that alert message above
 */
    @IBAction func submitButtonTapped(_ sender: Any) {
  
        let uEmail = userEmail.text // sets uEmail to the value entered by user
        let uPassword = userPass.text // sets uPassword to value entered by user
        let uVerify = verify.text // sets uVerify to value entered by user
        
        //check empty fields
        if((uEmail?.isEmpty)!||(uPassword?.isEmpty)!||(uVerify?.isEmpty)!)
        {
            //display error Message
            displayMyAlertMessage(userMessage: "All fields are required")
            return
        }
        if(uPassword != uVerify)
        {
            //display alert Message
            displayMyAlertMessage(userMessage: "Passwords do not match")
            return
        }
        
        let requestURL = NSURL(string: URL_REGISTER)
        
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        //setting the method to post
        request.httpMethod = "POST"
        
        //getting values from text fields
        let userName=userEmail.text
        let userPassword = userPass.text
        
        //creating the post parameter by concatenating the keys and values from text field
        let postParameters = "name="+userName!+"&password="+userPassword!;
        
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
    
    
    @IBAction func backButtonTapped(_ sender: Any)
    {
        //incase we want to do anything else when user goes back to previous screen (login screen)
    }
    
    
}
