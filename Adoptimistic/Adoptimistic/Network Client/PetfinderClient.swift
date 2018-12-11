//
//  PetfinderClient.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class PetfinderClient {
    
    static let shared = PetfinderClient()
    
    //Search for pets from location and other optional parameters (pet.find)
    func findPetsWith(location: String, animal: AnimalType? = nil, breed: String? = nil, size: SizeType? = nil, sex: GenderType? = nil, age: AgeType? = nil, offset: String? = nil, completion: @escaping ([PetRepresentation]?, Error?) -> Void ) {
        
        let url = baseURL.appendingPathComponent("pet").appendingPathExtension("find")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var parameters = ["key": apiKey, "format": "json", "location": location]
        if let animal = animal {
            parameters["animal"] = animal.rawValue
        } else if let breed = breed {
            parameters["breed"] = breed
        } else if let size = size {
            parameters["size"] = size.rawValue
        } else if let sex = sex {
            parameters["sex"] = sex.rawValue
        } else if let age = age {
            parameters["age"] = age.rawValue
        } else if let offset = offset {
            parameters["offset"] = offset
        }
        
        guard let requestURL = urlComponents?.url else { return }
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: requestURL)
        request.httpMethod  = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching pets with from \(location): \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(nil, NSError())
                return
            }
            
            if let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            
            do {
                let petFindResults = try JSONDecoder().decode(PetsFindResult.self, from: data)
                completion(petFindResults.pets, nil)
            } catch {
                NSLog("Error decoding pet representations: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    //find pet by id
    
    //fetch random pet in your area
    
    //Search shelter by id (shelter.get)
    func findShelter(byID id: String, completion: @escaping (ShelterRepresentation?, Error?) -> Void ) {
        let url = baseURL.appendingPathComponent("shelter").appendingPathExtension("get")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let parameters = ["key": apiKey, "format": "json", "id": id]
        
        guard let requestURL = urlComponents?.url else { return }
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: requestURL)
        request.httpMethod  = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching shelter with id \(id): \(error)")
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(nil, NSError())
                return
            }
            
            if let json = String(data: data, encoding: .utf8) {
                print(json)
            }
            
            do {
                let shelterResult = try JSONDecoder().decode(ShelterResult.self, from: data)
                completion(shelterResult.shelter, nil)
            } catch {
                NSLog("Error decoding shelter representation: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    //find all pets from one shelter
    
    //find all breeds for animal type
    
    private let apiKey = "9f7c1e0f8917b3c9b4dc048aac580f92"
    private let baseURL = URL(string: "http://api.petfinder.com")!
}
