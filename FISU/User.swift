//
//  OwnCalendar.swift
//  FISU
//
//  Created by Reda M on 27/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import Foundation
import CoreData
import UIKit


class User: NSManagedObject { // Toutes les fonctions liée à l'utilisateur
    
    class func checkLogin(name: String, surname: String, email: String) -> JSON?{
        // Fonction qui vérifie l'existance de l'utilisateur en base de donée
        let url = "https://fisuwebfinal-madonna.rhcloud.com/checkUserExist.php?emailUser="
        let finalUrl = url + email
        let result: JSON?
        let jsonRes = JSON.fromURL(finalUrl) // On envoie une requete GET avec l'email de l'user
        result = JSON(jsonRes) // On récupere success ou failure
        return result // On retourne ce qu'on a récupére
        
    }
    
    
    class func userExists() -> Bool{ // Verification de l'existance de l'user en coredata
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        do{
            let fetchResultUser = try managedObjectContext.executeFetchRequest(fetchRequestUser) as! [User]
            user = fetchResultUser
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if(user.count == 0){
            return false // User pas trouvé
        }
        return true // User trouvé
    }
    
    class func createUsers(name: String, surname: String, email: String) -> User?{ // La création de l'user
        
        var userToReturn: User? // La création se fait en deux temps 1: Base de donnée 2: Coredata
        var database: Bool = true
        
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/InsererUser.php") else{
            print("guard my url")
            return userToReturn
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "emailUser=\(email)&surname=\(surname)&name=\(name)" // On insere d'abords en base de donnée à l'aide d'une requete php
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if error != nil{
                print("error=\(error)")
                database = false
                return
            }
            guard let dataReceived = data else{
                print("guard datareceived")
                database = false
                return
            }
            let responseString = NSString(data: dataReceived, encoding: NSUTF8StringEncoding)
            print("response http request: \(responseString)")
            guard let reponse = responseString else{
                return
            }
            if(reponse != "success"){ // On récupere success si l'user a été inséré en base
                database = false // sinon on met database:Bool à false
            }
        }
        task.resume()
        // fin insert database
        
        if(database){ // Si l'user a bien été inséré en base de donnée
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext // On insere en coredata
            let UserDescription = NSEntityDescription.entityForName( "User", inManagedObjectContext : managedObjectContext)
            let request = NSFetchRequest()
            request.entity = UserDescription
            let pred = NSPredicate(format: "(emailAdress = %@)", email)
            request.predicate = pred
            var user: User? = nil
            do{
                var result = try managedObjectContext.executeFetchRequest(request)
                // on vérifie que le user n'existe pas déja dans le coredata
                
                if result.count == 0 {
                    
                    
                    let newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext:managedObjectContext ) as! User
                    newUser.emailAdress = email
                    newUser.name = name
                    newUser.surname = surname
                    
                    //m
                    user = newUser
                    do{
                        try managedObjectContext.save()
                        
                    } catch{
                        print("there was an error saving data")
                        
                    }
                }
                else {
                    // pour recuperer l user qui est deja dans le coredata
                    let user = result[0] as! User
                    userToReturn = user
                }
                
            }
                
            catch {
                print("insertion not done")
                
            }
            userToReturn = user
        }
        return userToReturn // on retourne l'utilisateur créee
    }
    
    class func getUserByUsername(username: String) -> User?{
        
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        let predicat = NSPredicate(format: "emailAdress=%@",username)
        fetchRequestUser.predicate = predicat
        do{
            let fetchResultUser = try managedObjectContext.executeFetchRequest(fetchRequestUser) as! [User]
            user = fetchResultUser
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return user[0]
    }
    
    class func getEventsFromUser(email: String) -> JSON?{ // On récup les events d'un user en base de donnée
        let url = "https://fisuwebfinal-madonna.rhcloud.com/ListeOwnEvent.php?mail="
        let finalUrl = url + email
        let events: JSON?
        let jsonSpeaker = JSON.fromURL(finalUrl)
        events = JSON(jsonSpeaker)
        return events // On retourne un JSON avec tous les events
    }
    
    
    class func AddEventToUser(emailUser: String, numEvent: String, hour: String, nom: String) -> Bool?{
        var success = true
        
        let url = "https://fisuwebfinal-madonna.rhcloud.com/InsererLien.php?"
        let finalUrl = url + "emailUser=\(emailUser)&numEvent=\(numEvent)"
        let result: JSON?
        let jsonRes = JSON.fromURL(finalUrl)
        result = JSON(jsonRes)
        guard let resultat = result else{
            return false
        }
        if(resultat[0]["results"].toString() == "success"){
            print("On rentre dans le core data")
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            guard let entityEvent = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext) else{
                print("guard entity")
                return false
            }
            
            let fetchRequestEvent = NSFetchRequest(entityName: "Event")
            
            
            let predicatEvent = NSPredicate(format: "num=%@",numEvent)
            fetchRequestEvent.predicate = predicatEvent
            do
            {
                let fetchResultsEvent =
                    try managedObjectContext.executeFetchRequest(fetchRequestEvent) as! [Event]
                // Vérification pour éviter les doublons, insertions si ok
                if (fetchResultsEvent.count == 0)
                {
                    print("pas de doublons")
                    let event: Event = Event(entity: entityEvent, insertIntoManagedObjectContext: managedObjectContext)
                    event.setValue(numEvent, forKey: "num")
                    event.setValue(hour, forKey: "hour")
                    event.setValue(nom, forKey: "nom")
                    do{
                        try managedObjectContext.save()
                        print("saved")
                    }
                    catch{
                        fatalError("Error saving event: \(error)")
                    }
                }
            }catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
                success = false
            }
        }
        return success
    }
    
    
    class func DeleteEventFromUser(emailUser: String, numEvent: String, hour: String, nom: String) -> Bool?{
        
        var success = true
        
        let url = "https://fisuwebfinal-madonna.rhcloud.com/EnleverLien.php?"
        let finalUrl = url + "emailUser=\(emailUser)&numEvent=\(numEvent)"
        let result: JSON?
        let jsonRes = JSON.fromURL(finalUrl)
        result = JSON(jsonRes)
        guard let resultat = result else{
            return false
        }
        if(resultat[0]["results"].toString() == "success"){
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            let fetchRequestEvent = NSFetchRequest(entityName: "Event")
            
            
            let predicatEvent = NSPredicate(format: "num=%@",numEvent)
            fetchRequestEvent.predicate = predicatEvent
            do
            {
                let fetchResultsEvent =
                    try managedObjectContext.executeFetchRequest(fetchRequestEvent) as! [Event]
                // Vérification pour éviter lde supprimer quelque chose qui existe pas
                if (fetchResultsEvent.count != 0)
                {
                    //let event: Event = Event(entity: entityEvent)
                    managedObjectContext.deleteObject(fetchResultsEvent[0])
                    do{
                        try managedObjectContext.save()
                        print("saved deletion")
                    }
                    catch{
                        fatalError("Error saving event: \(error)")
                    }
                }
            }catch let error as NSError {
                print("Could not fetch \(error), \(error.userInfo)")
                success = false
            }
        }
        return success
    }
    
    class func getActualUserMail() -> String{ // On récupere le mail de l'uitilisateur connecté et dans le core data (utile quand pas d'internet)
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        do{
            let fetchResultUser = try managedObjectContext.executeFetchRequest(fetchRequestUser) as! [User]
            user = fetchResultUser
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if(user.count == 0){
            return "No actual user"
        }
        guard let email = user[0].emailAdress else{
            return "No actual mail for user"
        }
        return email
    }
    
    
    class func getEventsOfActualUser(  c : String  , key : String) -> [Event]{ // On récup les events d'un user en core data (si pas de connexion internet)
        
        var events = [Event]()
        let context = ( UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let fetchRequestEvents = NSFetchRequest(entityName: "Event")
        do{
            let fetchResultEvents = try context.executeFetchRequest(fetchRequestEvents) as! [Event]
            events = fetchResultEvents
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return events
    }
}
