//
//  OwnCalendar+CoreDataProperties.swift
//  FISU
//
//  Created by Reda M on 29/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var name: String?
    @NSManaged var surname: String?
    @NSManaged var emailAdress: String?
    @NSManaged var events: Event?

}
