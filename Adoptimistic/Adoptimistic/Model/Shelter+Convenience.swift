//
//  Shelter+Convenience.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension Shelter {
    @discardableResult convenience init(shelterRep: ShelterRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.address = shelterRep.address
        self.city = shelterRep.city
        self.country = shelterRep.country
        self.email = shelterRep.email
        self.identifier = shelterRep.identifier
        self.latitude = shelterRep.latitude
        self.longitude = shelterRep.longitude
        self.name = shelterRep.name
        self.phone = shelterRep.phone
        self.state = shelterRep.state
        self.zipcode = shelterRep.zipcode
    }
}
