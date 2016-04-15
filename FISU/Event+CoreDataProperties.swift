//
//  Event+CoreDataProperties.swift
//  FISU
//
//  Created by Aurelien Licette on 25/03/2016.
//  Copyright © 2016 Reda M. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var categorie: String?
    @NSManaged var hour: String?
    @NSManaged var desc: String?
    @NSManaged var image: NSData?
    @NSManaged var nom: String?
    @NSManaged var day: Day?
    @NSManaged var place: Place?
    @NSManaged var speaker: Speaker?
}
