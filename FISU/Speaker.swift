//
//  Speaker.swift
//  FISU
//
//  Created by Aurelien Licette on 24/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class Speaker: NSManagedObject {


    //Création de l'ensemble des speakers au lancement de l'application.
    class func createSpeakers(speakers: [String]) {
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entitySpeaker = NSEntityDescription.entityForName("Speaker", inManagedObjectContext: managedObjectContext) else{
            return
        }
        
        let fetchRequestSpeaker = NSFetchRequest(entityName: "Speaker")

        
        let predicat = NSPredicate(format: "nom=%@",speakers[0])
        fetchRequestSpeaker.predicate = predicat
        do
        {
            let fetchResultsSpeaker =
            try managedObjectContext.executeFetchRequest(fetchRequestSpeaker) as! [Speaker]
            // Vérification pour éviter les doublons, insertions si ok
            if (fetchResultsSpeaker.count == 0)
            {
                let speaker = NSManagedObject(entity: entitySpeaker, insertIntoManagedObjectContext: managedObjectContext)
                speaker.setValue(speakers[0], forKey: "prenom")
                speaker.setValue(speakers[1], forKey: "nom")
                speaker.setValue(speakers[4], forKey: "desc")
                speaker.setValue(speakers[3], forKey: "nationalite")
                speaker.setValue(speakers[2], forKey: "profession")
                
                guard let image = UIImage(named: speakers[5]) else{
                    return
                }
                
                guard let uiimage = UIImageJPEGRepresentation(image, 1.0) else{
                    return
                }
                
                let imageData = NSData(data: uiimage)
                speaker.setValue(imageData, forKey: "profilePicture")
            }
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }

    }
    
    //Retourne un NSManagedObjet speaker en fonction du nom et prénom renseigné
    class func getSpeakerByNameSurname(name: String, surname: String) -> Speaker?{
        var speaker = [Speaker]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestSpeaker = NSFetchRequest(entityName: "Speaker")
        
        let predicatName = NSPredicate(format: "nom=%@",name)
        let predicatSurname = NSPredicate(format: "prenom=%@",surname)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatName,predicatSurname])
        fetchRequestSpeaker.predicate = compound
        do{
            let fetchResultSpeaker = try managedObjectContext.executeFetchRequest(fetchRequestSpeaker) as! [Speaker]
            speaker = fetchResultSpeaker
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return speaker[0]
    }
    
    //Retourne l'ensemble des speakers dans le coreData
    class func getAllSpeakers() -> [Speaker]?{
        var speaker = [Speaker]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestSpeaker = NSFetchRequest(entityName: "Speaker")

        do{
            let fetchResultSpeaker = try managedObjectContext.executeFetchRequest(fetchRequestSpeaker) as! [Speaker]
            for speakerResult in fetchResultSpeaker{
                speaker.append(speakerResult)
            }
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return speaker
    }

}
