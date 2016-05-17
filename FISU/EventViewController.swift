//
//  EventViewController.swift
//  FISU
//
//  Created by Reda Maachi on 24/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var EventTableView: UITableView!
    @IBOutlet weak var LabelDaySelected: UILabel!
    var daySelected : Day?
    var numberOfEvents:Int = 0
    var jsonEvents:JSON?
    
    func downloadAndUpdate() {
        jsonEvents = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEvent.php")
        if let obj = jsonEvents { // Je récupere le json de la page
            self.jsonEvents = JSON(obj)
            guard let laVue = self.view else{
                print("guard laCollection")
                return
            }
            guard let jsonEventsToLoop = self.jsonEvents else{
                print("guard jsonSpeakerToLoop")
                return
            }
            //laCollection.reloadData()
            var currentNumber: NSNumber = 0
            for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                currentNumber = key as! NSNumber
            }
            self.numberOfEvents = Int(currentNumber) + 1
        }
    }
    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Day" + String(section + 1)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.downloadAndUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.EventTableView.delegate = self
        self.EventTableView.dataSource = self

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfEvents
    }
    
    
    //Affichage des éléments de la variable events à l'écran
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IdEventCell") as! EventTableViewCell
        
        guard let thenamelabel = cell.LabelEvent else{
            return cell
        }
        guard let thedatelabel = cell.LabelEventTime else{
            return cell
        }
        guard let theimage = cell.ImageEvent else{
            return cell
        }
        
        guard let jsonEventsToLoop = self.jsonEvents else{
            print("guard jsonSpeakerToLoop")
            return cell
        }
        for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            let currentKey = key as! NSNumber
            if(currentKey == indexPath.row){
                thenamelabel.text = event["nameEvent"].toString()
                thedatelabel.text = event["HourEvent"].toString()
                guard let profileImageUrl = NSURL(string:event["imageSpeaker"].toString()) else{
                    return cell
                }
                guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
                    return cell
                }
                //print(speaker["descriptionSpeaker"].toString())
                let myImage =  UIImage(data: profileImageData)
                theimage.image = myImage
            }
        }
        
        return cell
    }
    
    //Quand l'utilisateur clique sur un évènement => redirection vers l'EventDetailViewController pour avoir le détail de l'évènements sélectionné
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EventDetailSegue") {
            if let indexPath = self.EventTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventDetailViewController
                detailVC.delete = false
            }
        }
        
    }
    
    
    
}
