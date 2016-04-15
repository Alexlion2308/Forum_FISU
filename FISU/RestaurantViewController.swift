//
//  RestaurantViewController.swift
//  FISU
//
//  Created by Aurelien Licette on 11/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData

class RestaurantViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    @IBOutlet weak var RestaurantTableView: UITableView!
    
    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "Restaurant")
        // Create a sort descriptor object that sorts on the "title"
        // property of the Core Data object
        let sortDescriptor = NSSortDescriptor(key: "nom", ascending: true)
        
        // Set the list of sort descriptors in the fetch request,
        // so it includes the sort descriptor
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        //Recherche des restaurants dans le core data
        do
        {
            let fetchResults =
            try managedObjectContext.executeFetchRequest(fetchRequest) as! [Restaurant]
            restaurants = fetchResults
            
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        self.RestaurantTableView.delegate = self
        self.RestaurantTableView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    //Affichage de la liste des restaurants grâce à la variable restaurants
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("IdRestaurantCell") as! RestaurantTableViewCell
        
        guard let restaurant = self.restaurants[indexPath.row].nom else {
            return cell
        }
        
        cell.LabelRestaurant.text = restaurant
        
        return cell
    }
    
    //En cliquant sur un restaurant, envoie les données relatives à celui-ci à l'écran RestaurantDetailViewController pour plus de précision sur ce lieu
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "RestaurantSegue") {
            if let indexPath = self.RestaurantTableView.indexPathForSelectedRow {
                let detailVC = segue.destinationViewController as! RestaurantDetailViewController
                detailVC.restaurantSelected = self.restaurants[indexPath.row]
            }
        }
    }


}
