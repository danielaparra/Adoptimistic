//
//  PetfinderEnums.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/10/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

enum AgeType: String, Decodable {
    case baby
    case young
    case adult
    case senior
}

enum AnimalType: String {
    case dog
    case cat
    case smallFurry// = "Small & Furry"
    case barnYard
    case bird
    case horse
    case rabbit
    case reptile
}

enum GenderType: String {
    case m = "M"
    case f = "F"
}

enum OptionType: String {
    case specialNeeds
    case noDogs
    case noCats
    case noKids
    case noClaws
    case hasShots
    case housebroken
    case altered // spayed or neutered
}

enum SizeType: String {
    case small = "S"
    case medium = "M"
    case large = "L"
    case extraLarge = "XL"
}

enum TCodingKey: String, CodingKey {
    case t = "$t"
}

enum OutputType: String {
    case id
    case basic
    case full
}
