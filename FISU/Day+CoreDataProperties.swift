//
//  Day+CoreDataProperties.swift
//  FISU
//
//  Created by Aurelien Licette on 24/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Day {

    @NSManaged var nom: String?
    @NSManaged var events: NSSet?
    

}
