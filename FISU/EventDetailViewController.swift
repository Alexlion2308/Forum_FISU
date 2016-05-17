//
//  EventDetailViewController.swift
//  FISU
//
//  Created by Reda M on 22/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class EventDetailViewController: UIViewController {
    
    var eventSelected : NSNumber?
    var delete : Bool?
    var usernameIfDelete : String?
    var jsonEvents: JSON?
    var jsonPlacesToPass: JSON?
    
    override func viewWillAppear(animated: Bool) {
        if(self.delete == true){
            self.addButton.hidden = true
            self.deleteButton.hidden = false
        }
        else{
            self.addButton.hidden = false
            self.deleteButton.hidden = true
        }
    }
    @IBAction func ButtonAddToOwnCalendar(sender: AnyObject) {
        
        guard let anEvent = self.eventSelected else {
            return
        }
        var inputTextField: UITextField?
        var passwordTextField: UITextField?
        let addEventAlert = UIAlertController(title: "Own calendar", message: "Add this event to your calendar ?", preferredStyle: UIAlertControllerStyle.Alert)
        addEventAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        addEventAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
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
            if(!(User.userExists(username))){
                User.createUsers([username, pasword])
                //User.AddEventToUser(username , newEvent: anEvent)
                self.delete = true
                self.viewWillAppear(false)
            }
            else{
                //User.AddEventToUser(username , newEvent: anEvent)
                self.delete = true
                self.viewWillAppear(false)
            }
        }))
        addEventAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Username"
            inputTextField = textField
        })
        addEventAlert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
            passwordTextField = textField
        })
        presentViewController(addEventAlert, animated: true, completion: nil)
    }
    
    @IBAction func ButtonDeleteFromOwnCalendar(sender: AnyObject) {
        
        guard let anEvent = self.eventSelected else {
            return
        }
        let removeEventAlert = UIAlertController(title: "Own calendar", message: "Remove this event from your calendar ?", preferredStyle: UIAlertControllerStyle.Alert)
        removeEventAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        removeEventAlert.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            guard let username = self.usernameIfDelete else{
                return
            }
            //User.DeleteEventFromUser(username, toDeleteEvent: anEvent)
            self.delete = false
            self.viewWillAppear(false)
        }))
        presentViewController(removeEventAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var LabelEventName: UILabel!
    
    @IBOutlet weak var SpeakerName: UIButton!
    
    @IBOutlet weak var LabelEventCategory: UILabel!
    
    @IBOutlet weak var TextEventDesc: UITextView!
    
    @IBOutlet weak var EventPlace: UIButton!
    
    @IBOutlet weak var EventDetailImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let jsonEventsToLoop = self.jsonEvents else{
            print("guard jsonEventsToLoop")
            return
        }
        for (key, events) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            guard let selection = self.eventSelected else{
                return
            }
            //print("Numéro con: " + events["numeroEvent"].toString()) // TRACE
            //print("Selectionné: " + String(selection)) // TRACE
            if(events["numeroEvent"].toString() == String(selection)){
                guard let profileImageUrl = NSURL(string:events["ImageEvent"].toString()) else{
                    return
                }
                guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
                    return
                }
                
                //print(speaker["descriptionSpeaker"].toString())
                let myImage =  UIImage(data: profileImageData)
                print(events["nameEvent"].toString())
                self.LabelEventName.text = events["nameEvent"].toString()
                self.LabelEventCategory.text = events["Categorie"].toString()
                self.TextEventDesc.text = events["DescEvent"].toString()
                self.EventPlace.setTitle(events["PlaceList"][0]["NomPlace"].toString(), forState: .Normal)
                self.jsonPlacesToPass = events["PlaceList"]
                self.EventDetailImage.image = myImage
                
            }
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let anEvent = self.eventSelected else {
            return
        }

        if (segue.identifier == "ProfileSpeakerDetailSegue") {
            let detailVC = segue.destinationViewController as! SpeakerProfileViewController
            detailVC.speakerSelected = 1
            //print("SPEAKER //////////// " + self.SpeakerName)
        }
        if (segue.identifier == "PlaceDetailSegue") {
            let detailVC = segue.destinationViewController as! PlaceViewController
            //detailVC.placeSelected = jsonPlacesToPass["NumPlace"]
            detailVC.jsonPlaces = jsonPlacesToPass
            //print("SPEAKER //////////// " + self.SpeakerName)
        }
    }
    
    
}
