//
//  PetRepresentation.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/10/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class PetRepresentation: NSObject, Decodable{
    let age: String //Age Type
    let animal: String //Animal Type
    let breeds: [String]?
    let petDescription: String?
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
    var shelter: ShelterRepresentation?
    let contact: Contact
    var isFavorite: Bool?
    
    class Contact: Decodable, Hashable, Equatable {
        
        static func == (lhs: PetRepresentation.Contact, rhs: PetRepresentation.Contact) -> Bool {
            return lhs.city == rhs.city &&
                lhs.address == rhs.address &&
                lhs.state == rhs.state &&
                lhs.zipcode == rhs.zipcode &&
                lhs.phone == rhs.phone &&
                lhs.email == rhs.email
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(city)
            hasher.combine(address)
            hasher.combine(state)
            hasher.combine(zipcode)
            hasher.combine(phone)
            hasher.combine(email)
        }
        
        let city: String
        let address: String?
        let state: String
        let zipcode: String
        let phone: String?
        let email: String?
        
        enum CodingKeys: String, CodingKey {
            case city
            case address1
            case address2
            case state
            case zip
            case phone
            case email
        }
        
        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let cityContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .city)
            let city = try cityContainer.decode(String.self, forKey: .t)
            let address1Container = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .address1)
            let address1 = try address1Container.decodeIfPresent(String.self, forKey: .t) ?? ""
            let address2Container = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .address2)
            let address2 = try address2Container.decodeIfPresent(String.self, forKey: .t) ?? ""
            let address = address1 + " " + address2
            let stateContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .state)
            let state = try stateContainer.decode(String.self, forKey: .t)
            let zipcodeContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .zip)
            let zipcode = try zipcodeContainer.decode(String.self, forKey: .t)
            let phoneContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .phone)
            let phone = try phoneContainer.decodeIfPresent(String.self, forKey: .t)
            let emailContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .email)
            let email = try emailContainer.decodeIfPresent(String.self, forKey: .t)
            
            self.city = city
            self.address = address
            self.state = state
            self.zipcode = zipcode
            self.phone = phone
            self.email = email
        }
    }
    
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
        case contact
    }
    
    enum OptionsCodingKeys: String, CodingKey {
        case option
    }
    
    enum MediaCodingKeys: String, CodingKey {
        case photos
    }
    
    enum PhotosCodingKeys: String, CodingKey {
        case photo
    }
    
    enum PhotoCodingKeys: String, CodingKey {
        case size = "@size"
        case t = "$t"
        case id = "@id"
    }
    
    enum BreedsCodingKeys: String, CodingKey {
        case breed
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let optionsContainer = try container.nestedContainer(keyedBy: OptionsCodingKeys.self, forKey: .options)
        
        var optionStrings: [String] = []
        do {
            var optionContainer = try optionsContainer.nestedUnkeyedContainer(forKey: .option)
            while !optionContainer.isAtEnd {
                let optionDictionary = try optionContainer.nestedContainer(keyedBy: TCodingKey.self)
                let option = try optionDictionary.decode(String.self, forKey: .t)
                optionStrings.append(option)
            }
        } catch {
            do {
                let optionContainer = try optionsContainer.nestedContainer(keyedBy: TCodingKey.self, forKey: .option)
                let optionString = try optionContainer.decode(String.self, forKey: .t)
                optionStrings.append(optionString)
            } catch {
                print("options might be nil")
            }
        }
        
        let ageContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .age)
        let age = try ageContainer.decode(String.self, forKey: .t)
        let sizeContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .size)
        let size = try sizeContainer.decode(String.self, forKey: .t)
        
        var photos = [String]()
        do {
            let mediaContainer = try container.nestedContainer(keyedBy: MediaCodingKeys.self, forKey: .media)
            let photosContainer = try mediaContainer.nestedContainer(keyedBy: PhotosCodingKeys.self, forKey: .photos)
            var photoContainer = try photosContainer.nestedUnkeyedContainer(forKey: .photo)
            
            while !photoContainer.isAtEnd {
                let photo = try photoContainer.nestedContainer(keyedBy: PhotoCodingKeys.self)
                let size = try photo.decode(String.self, forKey: .size)
                if size == "fpm" { //95 pixels wide or go for one size up
                    let photoURLString = try photo.decode(String.self, forKey: .t)
                    photos.append(photoURLString)
                }
            }
        } catch {
            
        }
        
        let idContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .id)
        let identifierString = try idContainer.decode(String.self, forKey: .t)
        let shelterPetIdContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .shelterPetId)
        let shelterPetId = try shelterPetIdContainer.decodeIfPresent(String.self, forKey: .t) ?? nil
        
        let breedsContainer = try container.nestedContainer(keyedBy: BreedsCodingKeys.self, forKey: .breeds)
        var breedStrings: [String] = []
        do {
            var breedContainer = try breedsContainer.nestedUnkeyedContainer(forKey: .breed)
            while !breedContainer.isAtEnd {
                let breedDictionary = try breedContainer.nestedContainer(keyedBy: TCodingKey.self)
                let breed = try breedDictionary.decode(String.self, forKey: .t)
                breedStrings.append(breed)
            }
        } catch {
            do {
                let breedContainer = try breedsContainer.nestedContainer(keyedBy: TCodingKey.self, forKey: .breed)
                let breed = try breedContainer.decode(String.self, forKey: .t)
                breedStrings.append(breed)
            } catch {
                print("breeds might be nil")
            }
        }
        
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
        
        let contact = try container.decode(Contact.self, forKey: .contact)
        
        self.options = optionStrings
        self.age = age
        self.size = size
        self.photos = photos
        self.identifier = Int16(identifierString) ?? 0 //Should never be zero.
        self.shelterPetId = shelterPetId
        self.breeds = breedStrings
        self.name = name
        self.sex = sex
        self.petDescription = description
        self.mix = mix
        self.shelterId = shelterId
        self.lastUpdate = lastUpdate
        self.animal = animal
        self.shelter = nil
        self.contact = contact
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
