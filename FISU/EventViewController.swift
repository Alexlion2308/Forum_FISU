//
//  EventViewController.swift
//  FISU
//
//  Created by Aurelien Licette on 24/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class EventViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var EventTableView: UITableView!
    @IBOutlet weak var LabelDaySelected: UILabel!
    var daySelected : Day?
    var events = [Event]()
    var numberOfEvents:Int = 0
    var jsonEvents:JSON?
    
    func downloadAndUpdate() {
        jsonEvents = JSON.fromURL("https://fisuwebfinal-madonna.rhcloud.com/ListeSpeaker.php")
        if let obj = jsonEvents { // Je récupere le json de la page
            self.jsonEvents = JSON(obj)
            guard let laCollection = self.view else{
                print("guard laCollection")
                return
            }
            guard let jsonSpeakerToLoop = self.jsonEvents else{
                print("guard jsonSpeakerToLoop")
                return
            }
            //laCollection.reloadData()
            var currentNumber: NSNumber = 0
            for (key, speaker) in jsonSpeakerToLoop { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                currentNumber = key as! NSNumber
            }
            self.numberOfEvents = Int(currentNumber) + 1
        }
    }
    override func viewWillAppear(animated: Bool) {
        self.downloadAndUpdate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let aday = daySelected else {
            return
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Event")
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "hour", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicat = NSPredicate(format: "day=%@",aday)
        fetchRequest.predicate = predicat
        
        // Récupération des évènements liés au jour sélectionné et affectation dans la variable events
        do
        {
            let fetchResults =
                try managedObjectContext.executeFetchRequest(fetchRequest) as! [Event]
            events = fetchResults
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        
        self.EventTableView.delegate = self
        self.EventTableView.dataSource = self
        
        
        
        self.LabelDaySelected.text = aday.nom
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
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
        
        let event = events[indexPath.row]
        
        thenamelabel.text = event.valueForKey("nom") as? String
        thedatelabel.text = event.valueForKey("hour") as? String
        guard let photo = event.valueForKey("image") as? NSData else{
            return cell
        }
        guard let imageEvent = UIImage(data: photo) else{
            return cell
        }
        theimage.image = imageEvent
        
        return cell
    }
    
    //Quand l'utilisateur clique sur un évènement => redirection vers l'EventDetailViewController pour avoir le détail de l'évènements sélectionné
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EventDetailSegue") {
            if let indexPath = self.EventTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventDetailViewController
                detailVC.eventSelected = self.events[indexPath.row]
                detailVC.delete = false
            }
        }
        
    }
    
    
    
}
