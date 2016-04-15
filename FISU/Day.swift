//
//  Day.swift
//  FISU
//
//  Created by Aurelien Licette on 24/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Day: NSManagedObject {

    //Création de l'ensemble des jours au lancement de l'application.
    class func createDay (day: String, eventSet:[[String]]) {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entityDay = NSEntityDescription.entityForName("Day", inManagedObjectContext: managedObjectContext) else{
            return
        }
        
        let fetchRequestDay = NSFetchRequest(entityName: "Day")
        
        let predicat = NSPredicate(format: "nom=%@",day)
        fetchRequestDay.predicate = predicat
        do
        {
            let fetchResults =
            try managedObjectContext.executeFetchRequest(fetchRequestDay) as! [Day]
            // Vérification pour éviter les doublons, insertions si ok
            if (fetchResults.count == 0)
            {
                let dayCreated = NSManagedObject(entity: entityDay, insertIntoManagedObjectContext: managedObjectContext)
                dayCreated.setValue(day, forKey: "nom")
                
                for events in eventSet {
                    Event.createEvents(day, event: events)

                }
                
            }
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
    }
    
    //Retourne un NSManagedObjet day en fonction du nom renseigné
    class func getDayByName(name : String)->Day? {
        var day = Day()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestDay = NSFetchRequest(entityName: "Day")
        
        let predicatName = NSPredicate(format: "nom=%@",name)
        fetchRequestDay.predicate = predicatName
        do{
            let fetchResultDay = try managedObjectContext.executeFetchRequest(fetchRequestDay) as! [Day]
            day = fetchResultDay[0]
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return day
    }
    
    
}



class Event: NSManagedObject {
    
    //Création de l'ensemble des évènements au lancement de l'application. Seule la classe Day peut créer ces évènements.
    private class func createEvents(day: String, event: [String]){
        
        var eventCount = [Event]()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entityEvent = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext) else{
            return
        }
        let fetchRequestEvent = NSFetchRequest(entityName: "Event")
    
        var predicat = NSPredicate(format: "nom=%@",event[1])
        fetchRequestEvent.predicate = predicat
        do
        {
            let fetchResults =
            try managedObjectContext.executeFetchRequest(fetchRequestEvent) as! [Event]
            eventCount = fetchResults
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
            
        // Vérification pour éviter les doublons, insertions si ok
        if (eventCount.count == 0)
        {
            let newEvent = NSManagedObject(entity: entityEvent, insertIntoManagedObjectContext: managedObjectContext)
            newEvent.setValue(event[0], forKey: "hour")
            newEvent.setValue(event[1], forKey: "nom")
            newEvent.setValue(event[2], forKey: "desc")
            newEvent.setValue(event[3], forKey: "categorie")
            
            guard let image = UIImage(named: event[4]) else{
                return
            }
            guard let uiimage = UIImageJPEGRepresentation(image, 1.0) else{
                return
            }
            
            let imageData = NSData(data: uiimage)
            newEvent.setValue(imageData, forKey: "image")
            
            /////// FETCHING THE DAY ///////
            
            
            let fetchRequestDay = NSFetchRequest(entityName: "Day")
                
            predicat = NSPredicate(format: "nom=%@",day)
            fetchRequestDay.predicate = predicat
                
            do
            {
                let fetchResults =
                try managedObjectContext.executeFetchRequest(fetchRequestDay) as! [Day]
                let day1 = fetchResults[0]
                newEvent.setValue(day1, forKey: "day")
            }catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            /////// FETCHING THE PLACE ///////
            
            
            let fetchRequestPlace = NSFetchRequest(entityName: "Place")
                
            predicat = NSPredicate(format: "nom=%@",event[7])
            fetchRequestPlace.predicate = predicat
                
            do
            {
                let fetchResults =
                try managedObjectContext.executeFetchRequest(fetchRequestPlace) as! [Place]
                let place = fetchResults[0]
                newEvent.setValue(place, forKey: "place")
            }catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
            /////// FETCHING THE SPEAKER ///////
            
            
            let fetchRequestSpeaker = NSFetchRequest(entityName: "Speaker")

                
            let predicatNom = NSPredicate(format: "nom=%@",event[5])

            let predicatPrenom = NSPredicate(format: "prenom=%@",event[6])

            let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatNom, predicatPrenom])
            
            fetchRequestSpeaker.predicate = compound
                
            do
            {
                let fetchResults =
                try managedObjectContext.executeFetchRequest(fetchRequestSpeaker) as! [Speaker]
                let speaker = fetchResults[0]
                newEvent.setValue(speaker, forKey: "speaker")
            }catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
            }
            
        }
        
    }
    
    //Retourne un NSManagedObjet event en fonction du nom renseigné
    class func getEventByName(name : String)->Event? {
        var event = Event()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestEvent = NSFetchRequest(entityName: "Event")
        
        let predicatName = NSPredicate(format: "nom=%@",name)
        fetchRequestEvent.predicate = predicatName
        do{
            let fetchResultEvent = try managedObjectContext.executeFetchRequest(fetchRequestEvent) as! [Event]
            event = fetchResultEvent[0]
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return event
    }

    
}
