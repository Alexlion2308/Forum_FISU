//
//  Restaurant.swift
//  FISU
//
//  Created by Aurelien Licette on 11/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Restaurant: NSManagedObject {

    // Création de la liste des restaurants
    class func createRestaurants(restaurants: [String]) {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entityRestaurant = NSEntityDescription.entityForName("Restaurant", inManagedObjectContext: managedObjectContext) else{
            return
        }
        let fetchRequestRestaurant = NSFetchRequest(entityName: "Restaurant")
        
        let predicat = NSPredicate(format: "nom=%@",restaurants[0])
        fetchRequestRestaurant.predicate = predicat
        do
        {
            let fetchResultsRestaurant =
            try managedObjectContext.executeFetchRequest(fetchRequestRestaurant) as! [Restaurant]
            if (fetchResultsRestaurant.count == 0)
            {
                let restaurant = NSManagedObject(entity: entityRestaurant, insertIntoManagedObjectContext: managedObjectContext)
                restaurant.setValue(restaurants[0], forKey: "nom")
                restaurant.setValue(restaurants[1], forKey: "numRue")
                restaurant.setValue(restaurants[2], forKey: "nomRue")
                restaurant.setValue(restaurants[3], forKey: "codePostal")
                restaurant.setValue(restaurants[4], forKey: "ville")
                restaurant.setValue(restaurants[5], forKey: "telephone")
                restaurant.setValue(restaurants[6], forKey: "type")
                restaurant.setValue(Float(restaurants[7]), forKey: "latitude")
                restaurant.setValue(Float(restaurants[8]), forKey: "longitude")
            }
        }
        catch let error as NSError
        {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }


}
