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
    var numberOfEvents:Int = 0
    var jsonEventsDay1:JSON?
    var jsonEventsDay2:JSON?
    var jsonEventsDay3:JSON?
    var jsonEventsDay4:JSON?
    var jsonEventsDay5:JSON?
    var jsonEventsDay6:JSON?
    var jsonEventsToLoop:JSON?
    var jsonEvents:JSON?
    var eventDayOne:JSON?
    var nombreEvent:Int=0
    var dateActuelle:String = "2016-05-24"
    var heureActuelle:String = "07:00"

    func downloadAndUpdate() {
        let lastWeekDate = NSCalendar.currentCalendar().dateByAddingUnit(.WeekOfYear, value: 0, toDate: NSDate(), options: NSCalendarOptions())!
        let styler = NSDateFormatter()
        styler.dateFormat = "yyyy-MM-dd"
        let dateString = styler.stringFromDate(lastWeekDate)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date24 = dateFormatter.stringFromDate(lastWeekDate)
        self.dateActuelle = dateString
        self.heureActuelle = date24
        jsonEventsDay1 = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEventDay1.php")
        jsonEventsDay2 = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEventDay2.php")
        jsonEventsDay3 = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEventDay3.php")
        jsonEventsDay4 = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEventDay4.php")
        jsonEventsDay5 = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEventDay5.php")
        jsonEventsDay6 = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeEventDay6.php")
        guard let eventsDay1 = jsonEventsDay1 else{
            return
        }
        guard let eventsDay2 = jsonEventsDay2 else{
            return
        }
        guard let eventsDay3 = jsonEventsDay3 else{
            return
        }
        guard let eventsDay4 = jsonEventsDay4 else{
            return
        }
        guard let eventsDay5 = jsonEventsDay5 else{
            return
        }
        guard let eventsDay6 = jsonEventsDay6 else{
            return
        }
        sectionNumber[0] = eventsDay1.count
        sectionNumber[1] = eventsDay2.count
        sectionNumber[2] = eventsDay3.count
        sectionNumber[3] = eventsDay4.count
        sectionNumber[4] = eventsDay5.count
        sectionNumber[5] = eventsDay6.count
        
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
        guard let theStamp = cell.imageStamp else{
            return cell
        }
        if(indexPath.section == 0){
            self.jsonEventsToLoop = self.jsonEventsDay1
        }
        if(indexPath.section == 1){
            self.jsonEventsToLoop = self.jsonEventsDay2
        }
        if(indexPath.section == 2){
            self.jsonEventsToLoop = self.jsonEventsDay3
        }
        if(indexPath.section == 3){
            self.jsonEventsToLoop = self.jsonEventsDay4
        }
        if(indexPath.section == 4){
            self.jsonEventsToLoop = self.jsonEventsDay5
        }
        if(indexPath.section == 5){
            self.jsonEventsToLoop = self.jsonEventsDay6
        }
        guard let toLoop = jsonEventsToLoop else{
            return cell
        }
        for (key, event) in toLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            let currentEvent = key as! NSNumber
            
            if(currentEvent == indexPath.row + nombreEvent && event["DateEvent"].toString() == sectionDay[indexPath.section]){
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
                theStamp.transform = CGAffineTransformMakeRotation((25.0 * CGFloat(M_PI)) / 180.0)
                //theStamp.hidden = true
                if(event["DateEvent"].toString() > self.dateActuelle){
                    theStamp.hidden = true
                }
                else{
                    theStamp.hidden = false
                }
                if(event["DateEvent"].toString() < self.dateActuelle){
                    theStamp.hidden = false
                }
                else{
                    theStamp.hidden = true
                }
                if(event["DateEvent"].toString() == self.dateActuelle){
                    if(event["HourEvent"].toString()[0...4] > self.heureActuelle){
                        theStamp.hidden = true
                    }
                    else{
                        theStamp.hidden = false
                    }
                }
            }
        }
        
        return cell
    }
    
    //Quand l'utilisateur clique sur un évènement => redirection vers l'EventDetailViewController pour avoir le détail de l'évènements sélectionné
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EventDetailSegue") {
            if let indexPath = self.EventTableView.indexPathForSelectedRow {
                if(indexPath.section == 0){
                    self.jsonEvents = self.jsonEventsDay1
                }
                if(indexPath.section == 1){
                    self.jsonEvents = self.jsonEventsDay2
                }
                if(indexPath.section == 2){
                    self.jsonEvents = self.jsonEventsDay3
                }
                if(indexPath.section == 3){
                    self.jsonEvents = self.jsonEventsDay4
                }
                if(indexPath.section == 4){
                    self.jsonEvents = self.jsonEventsDay5
                }
                if(indexPath.section == 5){
                    self.jsonEvents = self.jsonEventsDay6
                }
                let detailVC = segue.destinationViewController as! EventDetailViewController
                detailVC.delete = false
                detailVC.eventSelected = indexPath.row
                detailVC.jsonEvents = self.jsonEvents

            }
        }
        
    }
    
    
    
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[self.startIndex.advancedBy(i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end = start.advancedBy(r.endIndex - r.startIndex)
        return self[Range(start ..< end)]
    }
}
