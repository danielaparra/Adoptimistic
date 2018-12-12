//
//  PetController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import CoreData

class PetController {

    // MARK: - CRUD Methods with Core Data
    
    func addPetToFavorites(petRep: PetRepresentation, notes: String? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        Pet(petRep: petRep, notes: notes, context: context)
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error saving new favorite pet to core data: \(error)")
        }
    }
    
    func updatePetInFavorites(pet: Pet, notes: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        pet.notes = notes
        
        do {
            try CoreDataStack.shared.save(context: context)
        } catch {
            NSLog("Error updating favorite pet to core data: \(error)")
        }
    }
    
    func removePetFromFavorites(pet: Pet) {
        CoreDataStack.shared.mainContext.delete(pet)
        
        do {
            try CoreDataStack.shared.mainContext.save()
        } catch {
            NSLog("Error saving context after deleting pet: \(error)")
        }
    }
    
    
}
