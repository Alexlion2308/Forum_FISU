//
//  DayViewController.swift
//  FISU
//
//  Created by Aurelien Licette on 18/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    @IBOutlet weak var DayTableView: UITableView!
    
    var days = [Day]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Day")
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "nom", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Recupération des jours dans le core data et affectation du résultat à la variable days
        do
        {
            let fetchResults =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [Day]
            days = fetchResults

        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

        self.DayTableView.delegate = self
        self.DayTableView.dataSource = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return days.count
    }
    
    //Affichage des éléments de la variable days à l'écran
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
    
        let cell = tableView.dequeueReusableCellWithIdentifier("IdDayCell") as! DayTableViewCell
        
        
        guard let day = self.days[indexPath.row].nom else {
            return cell
        }

        cell.LabelDay.text = day
        
        return cell
        
    }

    
    //Quand l'utilisateur clique sur un jour => redirection vers l'EventViewController pour avoir la liste des évènements relative à ce jour
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "EventSegue") {
            if let indexPath = self.DayTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! EventViewController
                detailVC.daySelected = self.days[indexPath.row]
            }
        }
    }
    

}
