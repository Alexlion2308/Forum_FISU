//
//  Fisu.swift
//  FISU
//
//  Created by Aurelien Licette on 05/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import Foundation
import CoreData
import UIKit



class Fisu: NSManagedObject {
    

    //Initialisation de la création des jours en appelant la méthode de classe createDay de Day
    class func createDays(daySet: [String], eventSet1: [[String]]?, eventSet2: [[String]]?, eventSet3: [[String]]?, eventSet4: [[String]]?, eventSet5: [[String]]?, eventSet6: [[String]]?)
    {
        
              
        for days in daySet
        {
            if (days=="DAY 1: Monday, July 4"){
                guard let event1 = eventSet1 else {
                    return
                }
                Day.createDay(days,eventSet: event1)
            }
            
            if (days=="DAY 2: Tuesday, July 5"){
                guard let event2 = eventSet2 else {
                    return
                }
                Day.createDay(days,eventSet: event2)
            }
            
            if (days=="DAY 3: Wednesday, July 6"){
                guard let event3 = eventSet3 else {
                    return
                }
                Day.createDay(days,eventSet: event3)
            }
            
            if (days=="DAY 4: Thursday, July 7"){
                guard let event4 = eventSet4 else {
                    return
                }

                Day.createDay(days,eventSet: event4)
            }
            
            if (days=="DAY 5: Friday, July 8"){
                guard let event5 = eventSet5 else {
                    return
                }
                Day.createDay(days,eventSet: event5)
            }

            if (days=="DAY 6: Saturday, July 9"){
                guard let event6 = eventSet6 else {
                    return
                }
                Day.createDay(days,eventSet: event6)
            }

        }
    }
    
    //Initialisation de la création des lieux en appelant la méthode de classe createPlaces de Place
    class func createPlaces(placeSet: [[String]]) {
        
        for places in placeSet
        {
            Place.createPlaces(places)
        }
    }
    
    //Initialisation de la création des speakers en appelant la méthode de classe createSpeakers de Speaker
    class func createSpeakers(speakerSet: [[String]]) {
        
        for speakers in speakerSet
        {
            Speaker.createSpeakers(speakers)
        }

    }
    
    //Initialisation de la création des restaurants en appelant la méthode de classe createRestaurants de Restaurants
    class func createRestaurants(restaurantSet: [[String]]) {
        
        for restaurants in restaurantSet
        {
            Restaurant.createRestaurants(restaurants)
        }
    }
    
}
