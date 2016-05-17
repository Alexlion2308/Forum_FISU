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
    
    class func checkLogin(username: String, password: String) -> Bool{
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        let predicatUsername = NSPredicate(format: "username=%@",username)
        let predicatPassword = NSPredicate(format: "password=%@",password)
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
    
    
    class func userExists(username: String) -> Bool{
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        let predicat = NSPredicate(format: "username=%@",username)
        fetchRequestUser.predicate = predicat
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
    
    class func createUsers(userInfo: [String]) -> User?{
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let eventSetEmpty: Set<Event> = Set<Event>()
        
        
        guard let entityUser = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext) else{
            print("Entity not reached")
            return nil
        }
        
        let userConnected: User = User(entity: entityUser, insertIntoManagedObjectContext: managedObjectContext)
        userConnected.username = userInfo[0]
        userConnected.password = userInfo[1]
        userConnected.events = NSSet(set: eventSetEmpty)
        
        do{
            try managedObjectContext.save()
            print("Saved (createUsers)")
        }
        catch{
            fatalError("Error while saving user yeaaaaaah: \(error)")
        }
        print("Created (createUsers)")
        return userConnected
    }
    
    class func getUserByUsername(username: String) -> User?{
        
        var user = [User]()
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        let fetchRequestUser = NSFetchRequest(entityName: "User")
        
        let predicat = NSPredicate(format: "username=%@",username)
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
    
    class func getEventsFromUser(username: String) -> Set<Event>?{
        
        let currentSet: Set<Event> = Set<Event>()
        guard let userConnected = getUserByUsername(username) else{
            print("No userConnected to get (getEventsFromUser)")
            return nil
        }
        guard let currentUserSet = userConnected.events else{
            print("No ownEventSet to get (getEventsFromUser)")
            return currentSet
        }
        let events = (currentUserSet as! Set<Event>)
        return events
    }
    
    
    class func AddEventToUser(username: String) -> Bool?{
        
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/InsererLien.php") else{
            print("guard my url")
            return false
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "?mdp=fisufinal&speakers=tamere&place=tamere&nomEvent=tamere&categorie=tamere&descriptionEvent=tamere&image=tamere&heureEvent=tamere&dateEvent=tamere&notifier=tamere"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                print("error=\(error)")
                return
            }
            guard let dataReceived = data else{
                print("guard datareceived")
                return
            }
            let responseString = NSString(data: dataReceived, encoding: NSUTF8StringEncoding)
            print("response http request: \(responseString)")
        }
        task.resume()
        
        return true
    }
    
    
    class func DeleteEventFromUser(username: String) -> Bool?{
        
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/InsererLien.php") else{
            print("guard my url")
            return false
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "?mdp=fisufinal&speakers=tamere&place=tamere&nomEvent=tamere&categorie=tamere&descriptionEvent=tamere&image=tamere&heureEvent=tamere&dateEvent=tamere&notifier=tamere"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            
            if error != nil{
                print("error=\(error)")
                return
            }
            guard let dataReceived = data else{
                print("guard datareceived")
                return
            }
            let responseString = NSString(data: dataReceived, encoding: NSUTF8StringEncoding)
            print("response http request: \(responseString)")
        }
        task.resume()
        
        return true
    }
}
