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
    @discardableResult convenience init(petRep: PetRepresentation, notes: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.age = petRep.age
        self.animal = petRep.animal
        self.breeds = petRep.breeds
        self.identifier = petRep.identifier
        self.lastUpdate = dateFormatter.date(from: petRep.lastUpdate)
        self.mix = petRep.mix
        self.name = petRep.name
        self.options = petRep.options
        self.petDescription = petRep.description
        self.photos = petRep.photos
        self.sex = petRep.sex
        self.shelterId = petRep.shelterId
        self.shelterPetId = petRep.shelterPetId
        self.size = petRep.size
        self.notes = notes
        self.contact = Contact(petRep: petRep, context: context)
    }
}

let dateFormatter: DateFormatter = {
    let df = DateFormatter()
    return df
}()
