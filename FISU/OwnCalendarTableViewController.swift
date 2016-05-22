//
//  OwnCalendarTableViewController.swift
//  FISU
//
//  Created by Reda M on 27/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class OwnCalendarTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var OwnCalendarEventTableView: UITableView!
    var ownCalendar = NSArray()
    var events: JSON?
    var numberOfEvents: Int = 0
    var coreData: Bool = false
    //var ownEvents: [Event]?
    var ownEvents : NSFetchedResultsController = NSFetchedResultsController()

    
    func getAndCountOwnEvents() {
        let email = User.getActualUserMail()
        self.events = User.getEventsFromUser(email)
        guard let jsonEventsToLoop = self.events else{
            print("guard jsonSpeakerToLoop")
            return
        }
        var currentNumber: NSNumber = 0
        for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            currentNumber = key as! NSNumber
        }
        self.numberOfEvents = Int(currentNumber) + 1
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.OwnCalendarEventTableView.delegate = self
        self.OwnCalendarEventTableView.dataSource = self
    }
    
    func applicationWillEnterForeground(notification: NSNotification) {
        self.viewDidLoad()
        self.viewWillAppear(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() == true {
            self.getAndCountOwnEvents()
            print("Internet connection OK")
            User.getEventsOfActualUser("Event", key: "hour")
            self.getAndCountOwnEvents()
            self.OwnCalendarEventTableView.reloadData()
            if(!(User.userExists())){
                var home = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
                self.presentViewController(home, animated: true, completion: nil)
            }
        } else {
            print("Internet connection FAILED")
            var alert = UIAlertView(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            if(!(User.userExists())){
                print("quitter l'appli")
                //Quitter l'appli
            }
            else{
                print("on est dans le else")
                //On charge les events du core data
                self.coreData = true
                ownEvents = User.getEventsOfActualUser("Event", key: "hour")
                //ownEvents.delegate = self
                do {
                    try ownEvents.performFetch()
                } catch {
                    print("An error occured")
                }
                //self.numberOfEvents = ownEvents.count
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = ownEvents.sections {
            let currentSection = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ownCalendarCell", forIndexPath: indexPath) as! OwnCalendarTableViewCell
        
        
        guard let thenamelabel = cell.NameLabelOwnEvent else{
            return cell
        }
        guard let thedatelabel = cell.TimeLabelOwnEvent else{
            return cell
        }
        guard let jsonEventsToLoop = self.events else{
            print("guard jsonSpeakerToLoop")
            return cell
        }
        if(self.coreData == false){
            for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                let currentKey = key as! NSNumber
                if(currentKey == indexPath.row){
                    thenamelabel.text = event["nameEvent"].toString()
                    thedatelabel.text = event["HourEvent"].toString()
                }
            }
        }
        else{
            let event = ownEvents.objectAtIndexPath(indexPath) as! Event

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
