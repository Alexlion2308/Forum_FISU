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
    var event: JSON?
    var jsonPlacesToPass: JSON?
    var jsonSpeakersToPass1: JSON?
    var jsonSpeakersToPass2: JSON?
    
    override func viewWillAppear(animated: Bool) {
        if(self.delete == true){
            self.addButton.hidden = true
            self.deleteButton.hidden = false
        }
        else{
            self.addButton.hidden = false
            self.deleteButton.hidden = true
        }
        if(!(User.userExists())){
            self.addButton.hidden = true
            self.deleteButton.hidden = true
        }
    }
    @IBAction func ButtonAddToOwnCalendar(sender: AnyObject) {
        let addEventAlert = UIAlertController(title: "Own calendar", message: "Add this event to your calendar ?", preferredStyle: UIAlertControllerStyle.Alert)
        addEventAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        addEventAlert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let userMail = User.getActualUserMail()
            guard let cetEvent = self.event else{
                print("pas d'event cetEvent")
                return
            }
            let eventNum = cetEvent["numeroEvent"].toString()
            let eventHour = cetEvent["HourEvent"].toString()
            let eventNom = cetEvent["nameEvent"].toString()
            User.AddEventToUser(userMail , numEvent: eventNum, hour: eventHour, nom: eventNom)
            self.delete = true
            self.viewWillAppear(false)
        }))
        presentViewController(addEventAlert, animated: true, completion: nil)
    }
    
    @IBAction func ButtonDeleteFromOwnCalendar(sender: AnyObject) {
        let removeEventAlert = UIAlertController(title: "Own calendar", message: "Remove this event from your calendar ?", preferredStyle: UIAlertControllerStyle.Alert)
        removeEventAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        removeEventAlert.addAction(UIAlertAction(title: "Remove", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            let userMail = User.getActualUserMail()
            guard let cetEvent = self.event else{
                print("pas d'event cetEvent")
                return
            }
            let eventNum = cetEvent["numeroEvent"].toString()
            let eventHour = cetEvent["hourEvent"].toString()
            let eventNom = cetEvent["nomEvent"].toString()
            User.DeleteEventFromUser(userMail , numEvent: eventNum, hour: eventHour, nom: eventNom)
            self.delete = false
            self.viewWillAppear(false)
        }))
        presentViewController(removeEventAlert, animated: true, completion: nil)
    }
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var LabelEventName: UILabel!
    
    @IBOutlet weak var Speaker1Button: UIButton!
    
    @IBOutlet weak var Speaker2Button: UIButton!
    
    @IBOutlet weak var LabelHour: UILabel!
    
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
                print("pas de selection")
                return
            }
            if(String(key) == String(selection)){
                self.event = events
            }
        }   
        guard let event = self.event else{
            print("pas d'event event")
            return
        }
        guard let profileImageUrl = NSURL(string:event["ImageEvent"].toString()) else{
            print("pas de profil image")
            return
        }
        guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
            print("pas de profil image data")
            return
        }
        
        //print(speaker["descriptionSpeaker"].toString())
        let myImage =  UIImage(data: profileImageData)
        self.LabelEventName.text = event["nameEvent"].toString()
        self.LabelEventCategory.text = event["Categorie"].toString()
        self.LabelHour.text = event["HourEvent"].toString()
        if(event["DescEvent"].toString() == "null"){
            self.TextEventDesc.text = "Pas de decription disponible pour cet event."
        }
        else{
            self.TextEventDesc.text = event["DescEvent"].toString()
        }
        self.EventPlace.setTitle(event["PlaceList"][0]["NomPlace"].toString(), forState: .Normal)
        self.EventDetailImage.image = myImage
        // Passing parametre to other views
        self.jsonPlacesToPass = event["PlaceList"]
        self.Speaker1Button.setTitle(event["SpeakersList"][0]["NomSpeaker"].toString()[0] + ". " + event["SpeakersList"][0]["PrenomSpeaker"].toString(), forState: .Normal)
        self.Speaker2Button.setTitle(event["SpeakersList"][1]["NomSpeaker"].toString()[0] + ". " + event["SpeakersList"][1]["PrenomSpeaker"].toString(), forState: .Normal)
        self.jsonSpeakersToPass1 = event["SpeakersList"][0]
        self.jsonSpeakersToPass2 = event["SpeakersList"][1]

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "SpeakerDetailSegue1") {
            let detailVC = segue.destinationViewController as! SpeakersCollectionViewController
            detailVC.jsonSpeakers = jsonSpeakersToPass1
            detailVC.eventSpeaker = true
        }
        if (segue.identifier == "SpeakerDetailSegue2") {
            let detailVC = segue.destinationViewController as! SpeakersCollectionViewController
            detailVC.jsonSpeakers = jsonSpeakersToPass2
            detailVC.eventSpeaker = true
        }
        if (segue.identifier == "PlaceDetailSegue") {
            let detailVC = segue.destinationViewController as! PlaceViewController
            detailVC.jsonPlaces = jsonPlacesToPass
        }
    }
    
    
}
