//
//  AppDelegate.swift
//  FISU
//
//  Created by Reda M on 02/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    var notificationSettings: UIUserNotificationSettings?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        if Reachability.isConnectedToNetwork() == false {
            print("Internet connection FAILED")
            let alert = UIAlertView(title: "WARNING", message: "You must be connected to internet to register to events. Your own calendar will be visible without internet connection once you are registred. But your will not be able to add or delete events", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
            //var own = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OwnCalendarViewController") as UIViewController
            //set properties of login
            //presentViewController(own, animated: true, completion: nil)
            //root.presentViewController(own, animated: true, completion: nil)
            self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
            guard let window = self.window else{
                print("no window")
                return false
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewControllerWithIdentifier("OwnCalendarViewController")
            
            window.rootViewController = initialViewController
            window.makeKeyAndVisible()
        }
        let notificationTypes : UIUserNotificationType = [.Alert, .Badge, .Sound]
        notificationSettings = UIUserNotificationSettings(forTypes: notificationTypes, categories: nil)
        guard let settingNotif = self.notificationSettings else{
            return false
        }
        UIApplication.sharedApplication().registerUserNotificationSettings(settingNotif)
        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        GMSServices.provideAPIKey("AIzaSyAEtmY3vdAP89Si76FsqSjfb7VjLDYu3bQ")
        
        return true
    }

    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {

        let characterSet: NSCharacterSet = NSCharacterSet(charactersInString: "<>")
        let tokenString: String = (deviceToken.description as NSString).stringByTrimmingCharactersInSet(characterSet).stringByReplacingOccurrencesOfString(" ", withString: "") as String
        
        print("Device Token: \(tokenString)")
        
        guard let settingNotif = self.notificationSettings else{
            return
        }
        
        let pushBadge = settingNotif.types.contains(.Badge) ? "enabled" : "disabled"
        let pushAlert = settingNotif.types.contains(.Alert) ? "enabled" : "disabled"
        let pushSound = settingNotif.types.contains(.Sound) ? "enabled" : "disabled"
        
        
        let myDevice = UIDevice();
        let deviceName = myDevice.name
        let deviceModel = myDevice.model
        let systemVersion = myDevice.systemVersion
        guard let identifier = myDevice.identifierForVendor else{
            print("guard identifier")
            return
        }
        let deviceId = identifier.UUIDString
        
        
        var appName: String?
        if let appDisplayName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleDisplayName"){
            appName = appDisplayName as? String
        } else{
            appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as? String
        }
        
        let appVersion = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleVersion") as? String
        
        
        guard let myUrl = NSURL(string: "https://fisuwebfinal-madonna.rhcloud.com/apns/apns.php") else{
            print("guard my url")
            return
        }
        let request  = NSMutableURLRequest(URL: myUrl)
        request.HTTPMethod = "POST"
        
        let postString = "task=register&appname=\(appName)&appversion=\(appVersion)&deviceuid=\(deviceId)&devicetoken=\(tokenString)&devicename=\(deviceName)&devicemodel=\(deviceModel)&deviceversion=\(systemVersion)&pushbadge=\(pushBadge)&pushalert=\(pushAlert)&pushsound=\(pushSound)"
        
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
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print(error.localizedDescription)
        print(error)
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        print("Message detail: \(userInfo)")
        if let aps = userInfo["aps"] as? NSDictionary{
            let alertMessage = aps["alert"] as? String

            let myAlert = UIAlertController(title: "A change has occured in the events", message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            let okAction = UIAlertAction(title: "Okey", style: UIAlertActionStyle.Default , handler: nil)
            myAlert.addAction(okAction)
            guard let fenetre = self.window else{
                return
            }
            guard let racine = fenetre.rootViewController else{
                return
            }
            racine.presentViewController(myAlert, animated: true, completion: nil)
        }
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