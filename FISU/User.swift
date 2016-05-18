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


class User: NSManagedObject {
    
    class func checkLogin(name: String, surname: String, email: String) -> Bool{
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        let predicatUsername = NSPredicate(format: "name=%@",name)
        let predicatPassword = NSPredicate(format: "surname=%@",surname)
        let predicatEmail = NSPredicate(format: "emailAdress=%@",email)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicatUsername,predicatPassword])
        
        fetchRequestUser.predicate = compound
        do{
            let fetchResultUser = try managedObjectContext.executeFetchRequest(fetchRequestUser) as! [User]
            user = fetchResultUser
        }
        catch let error as NSError{
            print("Could not fetch \(error), \(error.userInfo)")
        }
        if(user.count == 0){
            return false
        }
        return true
    }
    
    
    class func userExists() -> Bool{
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
            return false
        }
        return true
    }
    
    class func createUsers(name: String, surname: String, email: String) -> User?{
        
        var userToReturn: User?
        var database: Bool = true
        // TODO insert in the database
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/InsererUser.php") else{
            print("guard my url")
            return userToReturn
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "emailUser=\(email)&surname=\(surname)&name=\(name)"
        
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
            if(responseString != "success"){
                database = false
            }        }
        task.resume()
        // fin insert database
        if(database){
            
            let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            
            guard let entityUser = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext) else{
                print("Entity not reached")
                return nil
            }
            
            userToReturn = User(entity: entityUser, insertIntoManagedObjectContext: managedObjectContext)
            guard let user = userToReturn else{
                print("guard user = userToReturn")
                return userToReturn
            }
            user.name = name
            user.surname = surname
            user.emailAdress =  email
            
            do{
                try managedObjectContext.save()
                print("Saved (createUsers)")
            }
            catch{
                fatalError("Error while saving user yeaaaaaah: \(error)")
            }
            print("Created (createUsers)")
            
            return user
        }
        else{
            return userToReturn
        }
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
    
    class func getEventsFromUser(email: String) -> JSON?{
        let url = "https://fisuwebfinal-madonna.rhcloud.com/ListeOwnEvent.php?mail="
        let finalUrl = url + email
        let events: JSON?
        let jsonSpeaker = JSON.fromURL(finalUrl)
        events = JSON(jsonSpeaker)
        return events
    }
    
    
    class func AddEventToUser(emailUser: String, numEvent: String, hour: String, nom: String) -> Bool?{
        var success = true
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/InsererLien.php") else{
            print("guard my url")
            return false
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "emailUser=\(emailUser)&numEvent=\(numEvent)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if error != nil{
                print("error=\(error)")
                success = false
                return
            }
            guard let dataReceived = data else{
                print("guard datareceived")
                success = false
                return
            }
            let responseString = NSString(data: dataReceived, encoding: NSUTF8StringEncoding)
            print("response http request: \(responseString)")
            if(responseString != "success"){
                success = false
            }
        }
        task.resume()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entitySpeaker = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext) else{
            return false
        }
        
        let fetchRequestEvent = NSFetchRequest(entityName: "Event")
        
        
        let predicatEvent = NSPredicate(format: "num=%@",numEvent)
        fetchRequestEvent.predicate = predicatEvent
        do
        {
            let fetchResultsSpeaker =
                try managedObjectContext.executeFetchRequest(fetchRequestEvent) as! [Event]
            // Vérification pour éviter les doublons, insertions si ok
            if (fetchResultsSpeaker.count == 0)
            {
                let event = NSManagedObject(entity: entitySpeaker, insertIntoManagedObjectContext: managedObjectContext)
                event.setValue(numEvent, forKey: "num")
                event.setValue(hour, forKey: "hour")
                event.setValue(nom, forKey: "nom")
                let fetchRequestUser = NSFetchRequest(entityName: "User")
                
                let predicatUser = NSPredicate(format: "emailAdress=%@",emailUser)
                fetchRequestUser.predicate = predicatUser
                
                do
                {
                    let fetchResults =
                        try managedObjectContext.executeFetchRequest(fetchRequestUser) as! [Day]
                    let user = fetchResults[0]
                    event.setValue(user, forKey: "users")
                }catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                    success = false
                }
                
            }
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            success = false
        }
        
        return success
    }
    
    
    class func DeleteEventFromUser(emailUser: String, numEvent: String, hour: String, nom: String) -> Bool?{
        
        var success = true
        
        
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/EnleverLien.php") else{
            print("guard my url")
            return false
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "emailUser=\(emailUser)&numEvent=\(numEvent)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if let httpStatus = response as? NSHTTPURLResponse where httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response)")
            }
            if error != nil{
                print("error=\(error)")
                success = false
                return
            }
            guard let dataReceived = data else{
                print("guard datareceived")
                success = false
                return
            }
            let responseString = NSString(data: dataReceived, encoding: NSUTF8StringEncoding)
            print("response http request: \(responseString)")
            if(responseString != "success"){
                success = false
            }
        }
        task.resume()
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entitySpeaker = NSEntityDescription.entityForName("Event", inManagedObjectContext: managedObjectContext) else{
            return false
        }
        
        let fetchRequestEvent = NSFetchRequest(entityName: "Event")
        
        
        let predicatEvent = NSPredicate(format: "num=%@",numEvent)
        fetchRequestEvent.predicate = predicatEvent
        do
        {
            let fetchResultsSpeaker =
                try managedObjectContext.executeFetchRequest(fetchRequestEvent) as! [Event]
            // Vérification pour éviter les doublons, insertions si ok
            if (fetchResultsSpeaker.count == 0)
            {
                let event = NSManagedObject(entity: entitySpeaker, insertIntoManagedObjectContext: managedObjectContext)
                /*event.setValue(numEvent, forKey: "num") ENlever l'event
                 event.setValue(hour, forKey: "hour")
                 event.setValue(nom, forKey: "nom")*/
                let fetchRequestUser = NSFetchRequest(entityName: "User")
                
                let predicatUser = NSPredicate(format: "emailAdress=%@",emailUser)
                fetchRequestUser.predicate = predicatUser
                
                do
                {
                    let fetchResults =
                        try managedObjectContext.executeFetchRequest(fetchRequestUser) as! [Day]
                    let user = fetchResults[0]
                    //event.setValue(user, forKey: "users")
                }catch let error as NSError {
                    print("Could not fetch \(error), \(error.userInfo)")
                    success = false
                }
                
            }
        }catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            success = false
        }
        return success
    }
    
    class func getActualUserMail() -> String{
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
            return "No actual user"
        }
        return email
    }
}
