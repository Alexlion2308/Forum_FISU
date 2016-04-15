//
//  Restaurant+CoreDataProperties.swift
//  FISU
//
//  Created by Aurelien Licette on 11/04/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Restaurant {

    @NSManaged var latitude: NSNumber?
    @NSManaged var nom: String?
    @NSManaged var longitude: NSNumber?
    @NSManaged var type: String?
    @NSManaged var telephone: String?
    @NSManaged var numRue: String?
    @NSManaged var nomRue: String?
    @NSManaged var ville: String?
    @NSManaged var codePostal: String?

}
