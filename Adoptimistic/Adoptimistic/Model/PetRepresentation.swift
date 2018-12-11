//
//  PetRepresentation.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/10/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct PetRepresentation: Decodable, Equatable {
    let age: AgeType
    let animal: String
    let breeds: [String]
    let description: String
    let identifier: Int16
    let lastUpdate: Date
    let mix: Bool
    let name: String
    let options: [String]
    let photos: [String]
    let sex: String
    let shelterId: String
    let shelterPetId: String
    let size: String
}

struct PetRepResults {
    
}
