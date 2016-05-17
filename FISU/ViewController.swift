//
//  ViewController.swift
//  FISU
//
//  Created by Reda M on 02/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit


class ViewController: UIViewController{

    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var connect: UIButton!
    
    @IBAction func continueWOConnect(sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.mainScreen().bounds)
        backgroundImage.image = UIImage(named: "dune.jpg")
        self.view.insertSubview(backgroundImage, atIndex: 0)
        // Do any additional setup after loading the view, typically from a nib.
        print("View did load OK.")
        displayWalkthroughs()
    }
    
    func displayWalkthroughs()
    {
        // check if walkthroughs have been shown
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let displayedWalkthrough = userDefaults.boolForKey("DisplayedWalkthrough")
        
        // if we haven't shown the walkthroughs, let's show them
        if !displayedWalkthrough {
            // instantiate neew PageVC via storyboard
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "ownCalendarSegue" {
            guard let theUser = usernameTextField else{
                return false
            }
            guard let finaleUsername = theUser.text else{
                return false
            }
            guard let thePass = passwordTextField else{
                return false
            }
            guard let finalePassword = thePass.text else{
                return false
            }
            if (finaleUsername.isEmpty) {
                
                let noUsernameAlert = UIAlertController()
                noUsernameAlert.title = "No username"
                noUsernameAlert.message = "Please enter username"
                noUsernameAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                presentViewController(noUsernameAlert, animated: true, completion: nil)

                return false
            }
            else if(!(User.checkLogin(finaleUsername, password: finalePassword)) && User.userExists(finaleUsername)){
                let wrongPass = UIAlertController()
                wrongPass.title = "Wrong password"
                wrongPass.message = "Correct your password or register"
                wrongPass.addAction(UIAlertAction(title: "Understand", style: UIAlertActionStyle.Default, handler: nil))
                presentViewController(wrongPass, animated: true, completion: nil)
                
                return false
            }
            else if(!(User.userExists(finaleUsername))){
                var inputTextField: UITextField?
                var passwordTextField: UITextField?
                let addUserAlert = UIAlertController(title: "User does not exist", message: "Create this user ?", preferredStyle: UIAlertControllerStyle.Alert)
                addUserAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
                addUserAlert.addAction(UIAlertAction(title: "Create", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    guard let textField = inputTextField else{
                        print("No imputTextfield")
                        return
                    }
                    guard let username = textField.text else{
                        print("Empty imputTextfield")
                        return
                    }
                    guard let textFieldP = passwordTextField else{
                        print("No passwordTextField")
                        return
                    }
                    guard let pasword = textFieldP.text else{
                        print("Empty passwordTextField")
                        return
                    }
                    if(pasword == "" || username == ""){
                        addUserAlert.title = "Please fill all the fields in order to create a new user"
                        self.presentViewController(addUserAlert, animated: true, completion: nil)
                        return
                    }
                    User.createUsers([username, pasword])
                }))
                addUserAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Username"
                    textField.text = finaleUsername
                    inputTextField = textField
                })
                addUserAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
                    textField.placeholder = "Password"
                    textField.secureTextEntry = true
                    passwordTextField = textField
                })

                presentViewController(addUserAlert, animated: true, completion: nil)
            }
        }
        else {
            return true
        }
        // by default, transition
        return true
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ownCalendarSegue") {
            let detailVC = segue.destinationViewController as! OwnCalendarTableViewController
            guard let theUser = usernameTextField else{
                return
            }
            guard let finaleUsername = theUser.text else{
                return
            }
            detailVC.username = finaleUsername
            print("ok")
        }
    }

    
        
}

