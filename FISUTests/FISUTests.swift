//
//  FISUTests.swift
//  FISUTests
//
//  Created by Reda M on 02/02/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import XCTest
@testable import FISU

class FISUTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testCoreData() {
        //////DATA INIT//////
        let daySet : [String] = ["DAY 1: Monday, July 4"]
        
        let eventsDay1 : [[String]] = [["09:00-12:30","Opening ceremony", "Welcoming ceremony, presentation of the activities schedule and of the speakers", "None", "image1","Timberlake","Justin","Corum"]]
        
        let placeSet : [[String]] = [["Corum","1","Boulevard Charles Warnery","34000","Montpellier","43.61377","3.88225"], ["Institut de Botanique","163","Rue Auguste Broussonnet","34090","Montpellier","43.61606","3.87161"]]
        
        let speakerSet : [[String]] = [["Justin", "Timberlake", "Singer", "Belge", "This willfull man has beady chestnut eyes.", "profilePicture2"]]
        
        var speaker = Speaker?()
        
        var place = Place?()
        
        var event = Event?()
        
        var day = Day?()
        
        //////TESTS//////
        
        //////SPEAKER//////
        Fisu.createSpeakers(speakerSet)
        
        speaker = Speaker.getSpeakerByNameSurname("Timberlake", surname: "Justin")
        
        guard let aSpeaker = speaker else {
            return
        }
        
        print(aSpeaker.nom)
        
        //////PLACE//////
        Fisu.createPlaces(placeSet)
        
        place = Place.getPlaceByName("Corum")
        
        guard let aPlace = speaker else {
            return
        }
        
        print(aPlace.nom)
        
        Fisu.createDays(daySet,eventSet1: eventsDay1, eventSet2:nil, eventSet3:nil, eventSet4:nil, eventSet5:nil, eventSet6:nil)
        
        day = Day.getDayByName("DAY 1: Monday, July 4")
        
        guard let aDay = day else {
            return
        }
        
        print(aDay.nom)
        
        event = Event.getEventByName("Opening cerenomy")
        
        guard let aEvent = event else {
            return
        }
        
        print(aEvent.nom)

    }
    
}
