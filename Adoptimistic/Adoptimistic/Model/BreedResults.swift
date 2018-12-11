//
//  BreedResults.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

struct BreedResults: Decodable {
    let breeds: [String]
    
    enum CodingKeys: String, CodingKey {
        case petfinder
    }
    
    enum PetfinderCodingKeys: String, CodingKey {
        case breeds
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let petfinderContainer = try container.nestedContainer(keyedBy: PetfinderCodingKeys.self, forKey: .petfinder)
        var breedsContainer = try petfinderContainer.nestedUnkeyedContainer(forKey: .breeds)
        var breeds: [String] = []
        
        while !breedsContainer.isAtEnd {
            let breedContainer = try breedsContainer.nestedContainer(keyedBy: TCodingKey.self)
            let breedString = try breedContainer.decode(String.self, forKey: .t)
            breeds.append(breedString)
        }
        
        self.breeds = breeds
    }
}
