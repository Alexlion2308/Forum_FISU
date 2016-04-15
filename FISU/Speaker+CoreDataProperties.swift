//
//  Speaker+CoreDataProperties.swift
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

extension Speaker {

    @NSManaged var desc: String?
    @NSManaged var nationalite: String?
    @NSManaged var nom: String?
    @NSManaged var prenom: String?
    @NSManaged var profession: String?
    @NSManaged var events: NSSet?
    @NSManaged var profilePicture: NSData?

}
