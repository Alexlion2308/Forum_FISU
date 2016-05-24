//
//  OwnCalendarTableViewController.swift
//  FISU
//
//  Created by Reda M on 27/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class OwnCalendarTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate{
    
    @IBOutlet weak var OwnCalendarEventTableView: UITableView!
    var ownCalendar = NSArray()
    var events: JSON?
    var numberOfEvents: Int = 0
    var coreData: Bool = false
    var ownEvents: [Event]?
    //var ownEvents : NSFetchedResultsController = NSFetchedResultsController()
    
    
    func getAndCountOwnEvents() {
        let email = User.getActualUserMail()
        print(email)
        self.events = User.getEventsFromUser(email)
        print(self.events)
        guard let jsonEventsToLoop = self.events else{
            print("guard jsonSpeakerToLoop get and count")
            return
        }
        self.numberOfEvents = jsonEventsToLoop.count
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.OwnCalendarEventTableView.delegate = self
        self.OwnCalendarEventTableView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            self.getAndCountOwnEvents()
            print("Internet connection OK")
            if(!(User.userExists())){
                let home = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
                self.presentViewController(home, animated: true, completion: nil)
            }
            self.OwnCalendarEventTableView.reloadData()
        }
        else{
            self.coreData = true
            ownEvents = User.getEventsOfActualUser("Event", key: "hour")
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Reachability.isConnectedToNetwork() == false {
            let alert = UIAlertController(title: "No Internet Connection", message: "You will have only a list of events you registred for.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            }))
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Table view data source
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberToReturn: Int=0
        if(coreData){
            guard let mesEvents = ownEvents else{
                return 0
            }
            numberToReturn = mesEvents.count
        }
        else{
            guard let jsonEventsToLoop = self.events else{
                print("guard jsonSpeakerToLoop no coredata")
                return 0
            }
            numberToReturn = jsonEventsToLoop.count
        }
        return numberToReturn
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ownCalendarCell", forIndexPath: indexPath) as! OwnCalendarTableViewCell
        
        
        guard let thenamelabel = cell.NameLabelOwnEvent else{
            return cell
        }
        guard let thedatelabel = cell.TimeLabelOwnEvent else{
            return cell
        }
        print("Coredata: \(coreData)")
        if(coreData == false){
            guard let jsonEventsToLoop = self.events else{
                print("guard jsonSpeakerToLoop table view")
                return cell
            }
            for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                let currentKey = key as! NSNumber
                if(currentKey == indexPath.row){
                    thenamelabel.text = event["nameEvent"].toString()
                    thedatelabel.text = event["HourEvent"].toString()
                }
            }
        }
        else{
            guard let mesEvents = ownEvents else{
                return cell
            }
            print(ownEvents)
            let event = mesEvents[indexPath.row]
            
            guard let nomEvent = event.nom else {
                return cell
            }
            guard let hourEvent = event.hour else {
                return cell
            }
            thenamelabel.text = nomEvent
            thedatelabel.text = hourEvent
        }
        return cell
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? EventDetailViewController {
            self.getAndCountOwnEvents()
            self.OwnCalendarEventTableView.reloadData()
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return !(self.coreData)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "OwnEventDetailSegue") {
            if let indexPath = self.OwnCalendarEventTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventDetailViewController
                //detailVC.eventSelected = self.ownCalendar[indexPath.row] as? Event
                detailVC.delete = true
                detailVC.eventSelected = indexPath.row
                detailVC.jsonEvents = self.events
            }
        }
    }
    
    
    
}
