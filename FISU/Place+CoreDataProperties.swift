//
//  Place+CoreDataProperties.swift
//  FISU
//
//  Created by Reda M on 08/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Place {

    @NSManaged var codePostal: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var nom: String?
    @NSManaged var nomRue: String?
    @NSManaged var numRue: String?
    @NSManaged var ville: String?
    @NSManaged var events: NSSet?

}
