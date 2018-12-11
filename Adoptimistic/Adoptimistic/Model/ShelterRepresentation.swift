//
//  ShelterRepresentation.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct ShelterRepresentation: Decodable {
    let address: String
    let city: String
    let country: String
    let email: String
    let identifier: String
    let latitude: Double
    let longitude: Double
    let name: String
    let phone: String
    let state: String
    let zipcode: Int16
    
    enum CodingKeys: String, CodingKey {
        case country
        case longitude
        case name
        case phone
        case state
        case address2
        case email
        case city
        case zip
        case latitude
        case id
        case address1
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let countryContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .country)
        let country = try countryContainer.decode(String.self, forKey: .t)
        let longitudeContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .longitude)
        let longitude = try longitudeContainer.decode(Double.self, forKey: .t)
        let nameContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .name)
        let name = try nameContainer.decode(String.self, forKey: .t)
        let phoneContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .phone)
        let phone = try phoneContainer.decode(String.self, forKey: .t)
        let stateContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .state)
        let state = try stateContainer.decode(String.self, forKey: .t)
        
        let address1Container = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .address1)
        let address1 = try address1Container.decode(String.self, forKey: .t)
        let address2Container = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .address2)
        let address2 = try address2Container.decodeIfPresent(String.self, forKey: .t) ?? ""
        let address = address1 + " " + address2
        
        let emailContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .email)
        let email = try emailContainer.decode(String.self, forKey: .t)
        let cityContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .city)
        let city = try cityContainer.decode(String.self, forKey: .t)
        let zipcodeContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .zip)
        let zipcode = try zipcodeContainer.decode(Int16.self, forKey: .t)
        let latitudeContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .latitude)
        let latitude = try latitudeContainer.decode(Double.self, forKey: .t)
        let idContainer = try container.nestedContainer(keyedBy: TCodingKey.self, forKey: .id)
        let identifier = try idContainer.decode(String.self, forKey: .t)
        
        self.country = country
        self.longitude = longitude
        self.name = name
        self.phone = phone
        self.state = state
        self.address = address
        self.email = email
        self.city = city
        self.zipcode = zipcode
        self.latitude = latitude
        self.identifier = identifier
    }
}

struct ShelterResult: Decodable {
    let shelter: ShelterRepresentation
    
    enum CodingKeys: String, CodingKey {
        case petfinder
    }
    
    enum PetfinderCodingKeys: String, CodingKey {
        case shelter
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let petfinderContainer = try container.nestedContainer(keyedBy: PetfinderCodingKeys.self, forKey: .petfinder)
        let shelter = try petfinderContainer.decode(ShelterRepresentation.self, forKey: .shelter)
        
        self.shelter = shelter
    }
}
