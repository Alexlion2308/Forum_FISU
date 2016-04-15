//
//  UserTests.swift
//  FISU
//
//  Created by Reda M on 07/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//

import XCTest
import UIKit
@testable import FISU

class UserTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    
    func testGetUser(){
        
        
    }
    
    func testAddEventUser(){
        
        
    }
    
    func testCreateuser(){
        let leUser = User.createUsers(["toto", "toto"])
        XCTAssertNotNil(leUser,"User not initialised")
    }
    
    func testExistsuser(){
        let leUser = User.createUsers(["toto", "toto"])
        XCTAssertNotNil(leUser,"User not initialised")
        
        let beOrNotToBe = User.userExists("toto")
        XCTAssertTrue(beOrNotToBe, "User does not exist")
    }
    
    func testCheckuser(){
        let leUser = User.createUsers(["toto", "toto"])
        XCTAssertNotNil(leUser,"User not initialised")
        
        let beOrNotToBe = User.userExists("toto")
        XCTAssertTrue(beOrNotToBe, "User does not exist")
        
        let checking = User.checkLogin("toto", password: "toto")
        XCTAssertTrue(checking, "False password")
        
    }
    
    
}
