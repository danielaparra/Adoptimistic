//
//  Contact+Convenience.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/13/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension Contact {
    convenience init(petRep: PetRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.address = petRep.contact.address
        self.city = petRep.contact.city
        self.email = petRep.contact.email
        self.phone = petRep.contact.phone
        self.state = petRep.contact.state
        self.zipcode = petRep.contact.zipcode
    }
}
