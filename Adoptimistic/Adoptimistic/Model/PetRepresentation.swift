//
//  PetRepresentation.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/10/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct PetRepresentation: Decodable, Equatable {
    let age: String //Age Type
    let animal: String //Animal Type
    let breeds: [String]
    let description: String?
    let identifier: Int16
    let lastUpdate: String
    let mix: Bool
    let name: String
    let options: [String]?
    let photos: [String]
    let sex: String
    let shelterId: String
    let shelterPetId: String?
    let size: String //Size Type
    
    enum CodingKeys: String, CodingKey {
        case options
        case age
        case size
        case media
        case id
        case shelterPetId
        case breeds
        case name
        case sex
        case description
        case mix
        case shelterId
        case lastUpdate
        case animal
    }
    
    enum OptionsCodingKeys: String, CodingKey {
        case option
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
//        let optionsContainer = try container.nestedContainer(keyedBy: OptionsCodingKeys.self, forKey: .options)
//        var optionContainer = try optionsContainer.nestedUnkeyedContainer(forKey: .option)
//        var optionStrings: [String] = []
//        while !optionContainer.isAtEnd {
//            let optionDictionary = try optionContainer.nestedContainer(keyedBy: TCodingKey.self)
//            let option = try optionDictionary.decode(String.self, forKey: .t)
//            optionStrings.append(option)
//        }
        //haven't accounted for just one option or nil
        
        let ageContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .age)
        let age = try ageContainer.decode(String.self, forKey: .t)
        let sizeContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .size)
        let size = try sizeContainer.decode(String.self, forKey: .t)
        
        //media photos
        
        let idContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .id)
        let identifierString = try idContainer.decode(String.self, forKey: .t)
        let shelterPetIdContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .shelterPetId)
        let shelterPetId = try shelterPetIdContainer.decodeIfPresent(String.self, forKey: .t) ?? nil
        
        //breeds one or many
        
        let nameContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .name)
        let name = try nameContainer.decode(String.self, forKey: .t)
        let sexContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .sex)
        let sex = try sexContainer.decode(String.self, forKey: .t)
        let descriptionContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .description)
        let description = try descriptionContainer.decodeIfPresent(String.self, forKey: .t)
        let mixContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .mix)
        let mixString = try mixContainer.decode(String.self, forKey: .t)
        let mix: Bool = mixString == "yes" ? true : false
        let shelterIdContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .shelterId)
        let shelterId = try shelterIdContainer.decode(String.self, forKey: .t)
        let lastUpdateContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .lastUpdate)
        let lastUpdate = try lastUpdateContainer.decode(String.self, forKey: .t)
        let animalContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .animal)
        let animal = try animalContainer.decode(String.self, forKey: .t)
        
        self.options = [""]
        self.age = age
        self.size = size
        //photos
        self.photos = [""]
        self.identifier = Int16(identifierString) ?? 0 //Should never be zero.
        self.shelterPetId = shelterPetId
        //breeds
        self.breeds = [""]
        self.name = name
        self.sex = sex
        self.description = description
        self.mix = mix
        self.shelterId = shelterId
        self.lastUpdate = lastUpdate
        self.animal = animal
    }
}

struct PetRandomResult: Decodable {
    let pet: PetRepresentation
    
    enum CodingKeys: String, CodingKey {
        case petfinder
    }
    
    enum PetfinderCodingKeys: String, CodingKey {
        case pet
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let petfinderContainer = try container.nestedContainer(keyedBy: PetfinderCodingKeys.self, forKey: .petfinder)
        let pet = try petfinderContainer.decode(PetRepresentation.self, forKey: .pet)
        
        self.pet = pet
    }
}

struct PetsFindResult: Decodable {
    let pets: [PetRepresentation]
    let lastOffset: String
    
    enum CodingKeys: String, CodingKey {
        case petfinder
    }
    
    enum PetfinderCodingKeys: String, CodingKey {
        case pets
        case lastOffset
    }
    
    enum PetsCodingKeys: String, CodingKey {
        case pet
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let petfinderContainer = try container.nestedContainer(keyedBy: PetfinderCodingKeys.self, forKey: .petfinder)
        let lastOffsetContainer = try petfinderContainer.nestedContainer(keyedBy: TCodingKey.self, forKey: .lastOffset)
        let lastOffset = try lastOffsetContainer.decode(String.self, forKey: .t)
        let petsContainer = try petfinderContainer.nestedContainer(keyedBy: PetsCodingKeys.self, forKey: .pets)
        var petContainer = try petsContainer.nestedUnkeyedContainer(forKey: .pet)
        var pets = [PetRepresentation]()
        
        while !petContainer.isAtEnd {
            let pet = try petContainer.decode(PetRepresentation.self)
            pets.append(pet)
        }
        
        self.lastOffset = lastOffset
        self.pets = pets
    }
}
