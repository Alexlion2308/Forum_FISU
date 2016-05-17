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
        self.getAndCountOwnEvents()
        self.OwnCalendarEventTableView.delegate = self
        self.OwnCalendarEventTableView.dataSource = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if(!(User.userExists())){
            var home = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("HomeViewController") as UIViewController
            //set properties of login
            self.presentViewController(home, animated: true, completion: nil)
        }
        self.OwnCalendarEventTableView.reloadData()
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
        //print(events.count) //TRACE
        return numberOfEvents
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ownCalendarCell", forIndexPath: indexPath) as! OwnCalendarTableViewCell
        
        
        guard let thenamelabel = cell.NameLabelOwnEvent else{
            return cell
        }
        guard let thedatelabel = cell.TimeLabelOwnEvent else{
            return cell
        }
        guard let theimage = cell.ImageOwnEvent else{
            return cell
        }
        guard let jsonEventsToLoop = self.events else{
            print("guard jsonSpeakerToLoop")
            return cell
        }
        for (key, event) in jsonEventsToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
            print("Key: ")
            print(key)
            print("Event: ")
            print(event)
            let currentKey = key as! NSNumber
            if(currentKey == indexPath.row){
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
            }
        }
        return cell
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? EventDetailViewController {
            self.getAndCountOwnEvents()
            self.OwnCalendarEventTableView.reloadData()
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "OwnEventDetailSegue") {
            if let indexPath = self.OwnCalendarEventTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventDetailViewController
                //detailVC.eventSelected = self.ownCalendar[indexPath.row] as? Event
                detailVC.delete = true
                detailVC.eventSelected = indexPath.row + 1
                detailVC.jsonEvents = self.events
            }
        }
    }
    
    
    
}
