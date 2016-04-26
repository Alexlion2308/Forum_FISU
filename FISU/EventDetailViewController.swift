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
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var eventSelected : Event?
    var delete : Bool?
    var usernameIfDelete : String?
    var speaker : Speaker?
    var place : Place?
    
    
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
                User.AddEventToUser(username , newEvent: anEvent)
                self.delete = true
                self.viewWillAppear(false)
            }
            else{
                User.AddEventToUser(username , newEvent: anEvent)
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
            User.DeleteEventFromUser(username, toDeleteEvent: anEvent)
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
/*        if(self.delete == true){
            self.addButton.hidden = true
            self.deleteButton.hidden = false
        }
        else{
            self.addButton.hidden = false
            self.deleteButton.hidden = true
        }
*/
        
        guard let anEvent = self.eventSelected else {
            return
        }
        
        guard let aSpeaker = anEvent.speaker else {
            return
        }
        
        guard let aPlace = anEvent.place else {
            return
        }
        guard let photo = anEvent.image else{
            return
        }
        guard let imageEvent = UIImage(data: photo) else{
            return
        }
        
        self.speaker = aSpeaker
        self.place = aPlace
        
        self.LabelEventName.text = anEvent.nom
        self.SpeakerName.setTitle(aSpeaker.nom, forState: .Normal)
        self.LabelEventCategory.text = anEvent.categorie
        self.TextEventDesc.text = anEvent.desc
        self.EventPlace.setTitle(aPlace.nom, forState: .Normal)
        self.EventDetailImage.image = imageEvent
        
        
    }
    
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
        guard let aSpeaker = anEvent.speaker else {
            return
        }
        guard let aPlace = anEvent.place else {
            return
        }
        if (segue.identifier == "ProfileSpeakerDetailSegue") {
            let detailVC = segue.destinationViewController as! SpeakerProfileViewController
            detailVC.speakerSelected = aSpeaker
            //print("SPEAKER //////////// " + self.SpeakerName)
        }
        if (segue.identifier == "PlaceDetailSegue") {
            let detailVC = segue.destinationViewController as! PlaceViewController
            detailVC.placeSelected = aPlace
            //print("SPEAKER //////////// " + self.SpeakerName)
        }
    }
    
    
}
