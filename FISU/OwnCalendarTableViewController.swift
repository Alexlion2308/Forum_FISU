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
    
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    var username = String()
    @IBOutlet weak var OwnCalendarEventTableView: UITableView!
    var ownCalendar = NSArray()
    var events = NSSet()
    
    override func viewDidLoad() {

        
        super.viewDidLoad()
        guard let eventsTemporaire = User.getEventsFromUser(username) else{
            return
        }
        events = eventsTemporaire
        ownCalendar = Array(events)
        
        self.OwnCalendarEventTableView.delegate = self
        self.OwnCalendarEventTableView.dataSource = self
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        return events.count
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
        if(events.count != 0){
            let event = ownCalendar[indexPath.row]
            thenamelabel.text = event.valueForKey("nom") as? String
            thedatelabel.text = event.valueForKey("hour") as? String
            guard let photo = event.valueForKey("image") as? NSData else{
                return cell
            }
            guard let imageEvent = UIImage(data: photo) else{
                return cell
            }
            theimage.image = imageEvent
        }
        return cell
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "OwnEventDetailSegue") {
            if let indexPath = self.OwnCalendarEventTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventDetailViewController
                //detailVC.eventSelected = self.ownCalendar[indexPath.row] as? Event
                detailVC.delete = true
                detailVC.usernameIfDelete = username
            }
        }
    }
    
    
    
}
