//
//  ViewController.swift
//  FISU
//
//  Created by Reda M on 02/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit


class ViewController: UIViewController{
    
    @IBOutlet weak var emailAdress: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
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
        //displayWalkthroughs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "ownCalendarSegue" {
            guard let firstName = firstName.text else{
                return false
            }
            guard let lastName = lastName.text else{
                return false
            }
            guard let emailAdress = emailAdress.text else{
                return false
            }
            if (firstName.isEmpty || lastName.isEmpty || emailAdress.isEmpty) {
                let noUsernameAlert = UIAlertController()
                noUsernameAlert.title = "Empty fields"
                noUsernameAlert.message = "Please fill all the fields in order to create a new user"
                noUsernameAlert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                presentViewController(noUsernameAlert, animated: true, completion: nil)
                
                return false
            }
            print(User.checkLogin("reda", surname: "reda", email: "maachi.reda@gmail.com"){ responseExist in
                // here you get the "returned" value from the asynchronous task
                print(responseExist)
                if(responseExist == "degage"){
                    let wrongPass = UIAlertController()
                    wrongPass.title = "Email already token"
                    wrongPass.message = "Please correct your e-mail and register"
                    wrongPass.addAction(UIAlertAction(title: "Understand", style: UIAlertActionStyle.Default, handler: nil))
                }
            })
            /*else if(User.checkLogin(firstName, surname: lastName, email: emailAdress)){
             presentViewController(wrongPass, animated: true, completion: nil)
             return false
             }*/
            if(!(User.userExists())){
                User.createUsers(firstName, surname: lastName, email: emailAdress)
            }
        }
        else {
            return true
        }
        // by default, transition
        return true
    }
    
    
    /*    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
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
     }*/
    
    
    
}

