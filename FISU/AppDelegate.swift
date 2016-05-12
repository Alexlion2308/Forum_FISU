//
//  AppDelegate.swift
//  FISU
//
//  Created by Reda M on 02/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData
import Alamofire
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    var window: UIWindow?
    
    //Initialisation de l'ensemble de données destinées à être stockées dans le coreData
    
    var eventsDay1 : [[String]] = [["09:00-12:30","Opening ceremony", "Welcoming ceremony, presentation of the activities schedule and of the speakers", "None", "image1","Timberlake","Justin","Corum"], ["12:30-13:45","Lunch", "Eating session", "La catégorie des branlos", "image2","None","None","Maison Relations Internationales (MRI)"], ["14:15-15:15","Introduction to the week's aims/methodology", "Introduction to the week's aims/methodology", "Coaching", "image3","Timberlake","Justin","Institut de Botanique"]]
    
    var eventsDay2 : [[String]] = [["09:00-10:00","Plenary session: Values/Ethics/Integrity", "Plenary session: Values/Ethics/Integrity", "Social", "image1","Timberlake","Justin","Institut de Botanique"], ["10:15-11:15","Workshops: Values/Ethics/Integrity", "Workshops:  Values/Ethics/Integrity", "Social", "image2","Timberlake","Justin","Saint Charles"], ["11:15-11:30","Coffee break","Break","None","image3","Timberlake","Justin","Saint Charles"]]
    
    var eventsDay3 : [[String]] = [["09:00-10:00","Plenary session: Leadership", "Plenary session: Leadership", "Coaching", "image1","Timberlake","Justin","Institut de Botanique"], ["10:15-11:15","Workshops: Leadership", "Workshops:  Leadership", "Social", "image2","Timberlake","Justin","Saint Charles"], ["11:15-11:30","Coffee break", "Break", "None", "image3", "None","None","Saint Charles"]]
    
    var eventsDay4 : [[String]] = [["09:00-10:00","EuroMoov Center Visit", "EuroMoov Center Visit", "Expedition", "image1","Timberlake","Justin","UFR STAPS"], ["10:00-10:45","Sport Presentation : Handball", "Move your body!", "Sport", "image2","None","None","UFR STAPS"], ["11:00-12:30","Handball practice", "Sport!!!", "Sport", "image3", "None","None","Veyrassi"]]
    
    var eventsDay5 : [[String]] = [["09:00-10:00","Plenary session", "Plenary session: Gender equality/Equal opportunities or access", "Coaching", "image1","Timberlake","Justin","Institut de Botanique"], ["10:00-10:30","Coffe break", "Break", "None", "image2","None","None","Saint Charles"], ["10:30-11:30","Workshop", "Workshop: Gender equality/Equal opportunities or access", "Coaching", "image3", "Timberlake","Justin","Saint Charles"]]
    
    var eventsDay6 : [[String]] = [["09:00-11:00","Project presentation", "Presentation", "None", "image1","Timberlake","Justin","Institut de Botanique"], ["11:00-11:30","Deliberation", "Jury deliberation and outcome announcement", "None", "image2","Timberlake","Justin","Institut de Botanique"], ["11:30-12:30","Forum conclusions", "Forum conclusions", "None", "image3", "Timberlake","Justin","Institut de Botanique"]]
    
    
    var daySet : [String] = ["DAY 1: Monday, July 4", "DAY 2: Tuesday, July 5", "DAY 3: Wednesday, July 6", "DAY 4: Thursday, July 7", "DAY 5: Friday, July 8", "DAY 6: Saturday, July 9"]
    
    var placeSet : [[String]] = [["Corum","1","Boulevard Charles Warnery","34000","Montpellier","43.61377","3.88225"], ["Institut de Botanique","163","Rue Auguste Broussonnet","34090","Montpellier","43.61606","3.87161"], ["Maison Relations Internationales (MRI)","14","Descente en Barrat","34000","Montpellier","43.61305","3.87831"], ["Saint Charles","1500","Route de Mende","34100","Montpellier","43.63210","3.86836"], ["UFR STAPS","700","Avenue du Pic Saint-Loup","34090", "Montpellier","43.64108","3.85117"], ["Veyrassi","700","Avenue du Pic Saint-Loup","34090", "Montpellier","43.64108","3.85117"]]
    
    var speakerSet : [[String]] = [["None","None","None","None","None","None"],["Justin", "Timberlake", "Singer", "Belge", "This willfull man has beady chestnut eyes.", "profilePicture2"], ["Spparow", "Jack", "Acteur", "Belge", "Une belle description de la personne concernée", "profilePicture2"], ["Nous", "Prenom", "Pompiste", "Belge", "description", "profilePicture3"], ["Lacha", "Bernard", "Pompiste", "Belge", "description", "profilePicture4"], ["Lui", "Prenom", "Pompiste", "Belge", "description", "profilePicture5"] ,["Elle", "Prenom", "Pompiste", "Belge", "description", "profilePicture4"], ["Belge", "Belge", "Belge", "Belge", "Belge", "profilePicture3"]]
    
    var usersSet : [[String]] = [["reda", "reda"],["aurelien", "aurelien"]]
    
    var restaurantSet : [[String]] = [["La B des arts","20","Avenue du Dr Pezet","34090","Montpellier","0467040438","Cuisine Française","43.62878","3.86948"],["Burger'N'Co","1","Rue du Pila St Gély","34000","Montpellier","0411755482","Burger","43.61457","3.88130"]]
    
    var speakerCount = [Speaker]()
    var placeCount = [Place]()
    var eventCount = [Event]()
    
    
    
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        
        GMSServices.provideAPIKey("AIzaSyAEtmY3vdAP89Si76FsqSjfb7VjLDYu3bQ")
        //////////////////////// Test Alamofire //////////////////////////
        
        Alamofire.request(.GET, "https://fisuwebfinal-madonna.rhcloud.com/ListeEvent.php")
            .responseJSON { response in
                /*print("Requete: ")
                 print(response.request)  // original URL request
                 print("Reponse: ")
                 print(response.response) // URL response
                 print("Data: ")
                 print(response.data)  // server data
                 print("Result: ")
                 print(response.result)   // result of response serialization*/
                
                if let obj = response.result.value { // Je récupere le json de la page
                    let jsonEvent = JSON(obj)
                    jsonEvent.toString()
                    for (cle, event) in jsonEvent { // cle is NSNumber, event is another JSON object (event c'est chaque event)
                        //print(cle)
                        //print(event)
                        for (cleEvent, attributEvent) in event {
                            //print("========")
                            let json = JSON(cleEvent)
                            let jsonStr = json.toString()
                            if(jsonStr == "SpeakersList"){
                                if(attributEvent.toString() != "[]"){ // On regarde s'il y a des speakers
                                    for (cleSpeaker, attributSpeaker) in attributEvent { // La on récupere les speakers
                                        print(attributSpeaker)
                                        print(attributSpeaker["NomSpeaker"])
                                        print(attributSpeaker["PrenomSpeaker"])
                                        print(attributSpeaker["Profession"])
                                        print(attributSpeaker["EmailSpeaker"])
                                        print(attributSpeaker["NationaliteSpeaker"])
                                        print(attributSpeaker["DescSpeaker"])
                                    }
                                }
                                //print("StrB: " + b.toString())
                            }
                            //print(a)
                            //print(b)
                        }
                    }
                }
        }
        
        //////////////////////// APPLICATION INIT //////////////////////////
        
        //Call de toutes les fonctions de création du coreData
        
        User.createUsers(usersSet[0])
        
        Fisu.createRestaurants(restaurantSet)
        
        Fisu.createSpeakers(speakerSet)
        
        Fisu.createPlaces(placeSet)
        
        Fisu.createDays(daySet,eventSet1: eventsDay1,eventSet2: eventsDay2,eventSet3: eventsDay3,eventSet4: eventsDay4,eventSet5: eventsDay5,eventSet6: eventsDay6)
        
        
        /////////////////////// SAVE CONTEXT /////////////////////////
        do {
            try managedObjectContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
        
        
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "IG4-POLYTECH.FISU" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("FISU", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }
    
}