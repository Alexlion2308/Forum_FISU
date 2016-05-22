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
    
    
    
    let section = ["DAY 1 : Monday, July 4", "DAY 2 : Tuesday, July 5", "DAY 3 : Wednesday, July 6", "DAY 4 : Thursday, July 7", "DAY 5 : Friday, July 8", "DAY 6 : Friday, July 9"]
    let sectionDay = ["2016-07-04", "2016-07-05", "2016-07-06", "2016-07-07", "2016-07-08", "2016-07-09"]
    var sectionNumber = [0, 0, 0, 0, 0, 0]
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
            self.numberOfEvents = jsonEventsToLoop.count
            var currentNumber: NSNumber = 0
            for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                currentNumber = key as! NSNumber
                //print(event["DateEvent"]["2016-07-04"].count)
                if(event["DateEvent"].toString() == "2016-07-04"){
                    sectionNumber[0] = sectionNumber[0] + 1
                }
                if(event["DateEvent"].toString() == "2016-07-05"){
                    sectionNumber[1] = sectionNumber[1] + 1
                }
                if(event["DateEvent"].toString() == "2016-07-06"){
                    sectionNumber[2] = sectionNumber[2] + 1
                }
                if(event["DateEvent"].toString() == "2016-07-07"){
                    sectionNumber[3] = sectionNumber[3] + 1
                }
                if(event["DateEvent"].toString() == "2016-07-08"){
                    sectionNumber[4] = sectionNumber[4] + 1
                }
                if(event["DateEvent"].toString() == "2016-07-09"){
                    sectionNumber[5] = sectionNumber[5] + 1
                }
            }
        }
    }

    
    override func viewWillAppear(animated: Bool) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let displayedWalkthrough = userDefaults.boolForKey("DisplayedWalkthrough")
        
        // if we haven't shown the walkthroughs, let's show them
        if !displayedWalkthrough {
            // instantiate neew PageVC via storyboard
            if let pageViewController = storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? PageViewController {
                self.presentViewController(pageViewController, animated: true, completion: nil)
            }
        }
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
        return self.section.count
    }

    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let jsonEventsToLoop = self.jsonEvents else{
            print("guard jsonSpeakerToLoop")
            return 0
        }
        //print(sectionNumber[section])
        return sectionNumber[section]
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
            //if(event["DateEvent"].toString() == sectionDay[indexPath.section]){
                thenamelabel.text = event["nameEvent"].toString()
                thedatelabel.text = event["HourEvent"].toString()
                guard let profileImageUrl = NSURL(string:event["ImageEvent"].toString()) else{
                    return cell
                }
                guard let profileImageData = NSData(contentsOfURL: profileImageUrl) else{
                    return cell
                }
                //print(speaker["descriptionSpeaker"].toString())
                let myImage =  UIImage(data: profileImageData)
                theimage.image = myImage
            //}
        }
        
        return cell
    }
    
    //Quand l'utilisateur clique sur un évènement => redirection vers l'EventDetailViewController pour avoir le détail de l'évènements sélectionné
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EventDetailSegue") {
            if let indexPath = self.EventTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventDetailViewController
                detailVC.delete = false
                detailVC.eventSelected = indexPath.row
                detailVC.jsonEvents = self.jsonEvents

            }
        }
        
    }
    
    
    
}
