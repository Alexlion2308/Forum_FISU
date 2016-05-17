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
        
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        guard let entityUser = NSEntityDescription.entityForName("User", inManagedObjectContext: managedObjectContext) else{
            print("Entity not reached")
            return nil
        }
        
        let userConnected: User = User(entity: entityUser, insertIntoManagedObjectContext: managedObjectContext)
        userConnected.name = name
        userConnected.surname = surname
        userConnected.emailAdress =  email
        
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
    
    
    class func AddEventToUser(emailUser: String, numEvent: String) -> Bool?{
        
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
    
    
    class func DeleteEventFromUser(emailUser: String, numEvent: String) -> Bool?{
        
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
