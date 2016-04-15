//
//  Place.swift
//  FISU
//
//  Created by Reda M on 08/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Place: NSManagedObject {

        
        //Création des lieux 
        class func createPlaces(places: [String]) {
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            guard let entityPlace = NSEntityDescription.entityForName("Place", inManagedObjectContext: managedObjectContext) else{
                return
            }
            let fetchRequestPlace = NSFetchRequest(entityName: "Place")
            
            let predicat = NSPredicate(format: "nom=%@",places[0])
            fetchRequestPlace.predicate = predicat
            do
            {
                let fetchResultsPlace =
                    try managedObjectContext.executeFetchRequest(fetchRequestPlace) as! [Place]
                
                // Vérification pour éviter les doublons, insertions si ok

                if (fetchResultsPlace.count == 0)
                {
                    let place = NSManagedObject(entity: entityPlace, insertIntoManagedObjectContext: managedObjectContext)
                    place.setValue(places[0], forKey: "nom")
                    place.setValue(places[1], forKey: "numRue")
                    place.setValue(places[2], forKey: "nomRue")
                    place.setValue(places[3], forKey: "codePostal")
                    place.setValue(places[4], forKey: "ville")
                    place.setValue(Float(places[5]), forKey: "latitude")
                    place.setValue(Float(places[6]), forKey: "longitude")
                }
            }
            catch let error as NSError
            {
                print("Could not fetch \(error), \(error.userInfo)")
            }
        }
    
    
    //Retourne un NSManagedObjet Place en fonction du nom renseigné
    class func getPlaceByName(name: String) -> Place?{
        var place = Place()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestPlace = NSFetchRequest(entityName: "Place")
        
        let predicatName = NSPredicate(format: "nom=%@",name)
        fetchRequestPlace.predicate = predicatName
        do{
            let fetchResultPlace = try managedObjectContext.executeFetchRequest(fetchRequestPlace) as! [Place]
            place = fetchResultPlace[0]
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return place
    }
}
