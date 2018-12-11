//
//  Pet+Convenience.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/10/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

extension Pet {
    @discardableResult convenience init(petRep: PetRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.age = petRep.age
        self.animal = petRep.animal
        self.breeds = petRep.breeds
        self.identifier = petRep.identifier
        self.lastUpdate = petRep.lastUpdate
        self.mix = petRep.mix
        self.name = petRep.name
        self.options = petRep.options
        self.petDescription = petRep.description
        self.photos = petRep.photos
        self.sex = petRep.sex
        self.shelterId = petRep.shelterId
        self.shelterPetId = petRep.shelterPetId
        self.size = petRep.size
    }
}
