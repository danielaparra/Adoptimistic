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
    func findPets(near location: String, animal: AnimalType? = nil, breed: String? = nil, size: SizeType? = nil, sex: GenderType? = nil, age: AgeType? = nil, offset: String? = nil, completion: @escaping ([PetRepresentation]?, String?, Error?) -> Void ) {
        
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
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod  = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching pets from \(location): \(error)")
                completion(nil, nil, error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned by data task")
                completion(nil, nil, NSError())
                return
            }
            
            do {
                let petFindResults = try JSONDecoder().decode(PetsFindResult.self, from: data)
                completion(petFindResults.pets, petFindResults.lastOffset, nil)
            } catch {
                NSLog("Error decoding pet representations: \(error)")
                completion(nil, nil, error)
                return
            }
        }.resume()
    }
    
    //Fetch random pet by location and optional parameters (pet.getRandom)
    func getRandomPet(from location: String, animal: AnimalType? = nil, breed: String? = nil, size: SizeType? = nil, sex: GenderType? = nil, shelterId: String? = nil, output: OutputType = .basic, completion: @escaping (PetRepresentation?, Error?) -> Void ) {
        
        let url = baseURL.appendingPathComponent("pet").appendingPathExtension("getRandom")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var parameters = ["key": apiKey, "format": "json", "location": location, "output": output.rawValue]
        if let animal = animal {
            parameters["animal"] = animal.rawValue
        } else if let breed = breed {
            parameters["breed"] = breed
        } else if let size = size {
            parameters["size"] = size.rawValue
        } else if let sex = sex {
            parameters["sex"] = sex.rawValue
        } else if let shelterId = shelterId {
            parameters["shelterId"] = shelterId
        }
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod  = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching random pet from \(location): \(error)")
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
                let petRandomResult = try JSONDecoder().decode(PetRandomResult.self, from: data)
                completion(petRandomResult.pet, nil)
            } catch {
                NSLog("Error decoding pet representation: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    //Search shelter by id (shelter.get)
    func findShelter(byID id: String, completion: @escaping (ShelterRepresentation?, Error?) -> Void ) {
        let url = baseURL.appendingPathComponent("shelter").appendingPathExtension("get")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let parameters = ["key": apiKey, "format": "json", "id": id]
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        
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
    
    //Fetch all pets from a given shelter (shelter.getPets)
    
    func fetchAllPets(from shelterId: String, output: OutputType = .basic, offset: String? = nil, completion: @escaping ([PetRepresentation]?, Error?) -> Void ) {
        let url = baseURL.appendingPathComponent("shelter").appendingPathExtension("getPets")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        var parameters = ["key": apiKey, "format": "json", "id": shelterId, "output": output.rawValue]
        if let offset = offset {
            parameters["offset"] = offset
        }
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod  = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching pets from shelter id \(shelterId): \(error)")
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
                let petsFindResult = try JSONDecoder().decode(PetsFindResult.self, from: data)
                completion(petsFindResult.pets, nil)
            } catch {
                NSLog("Error decoding pet representations: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    //Fetch all breeds for a given animal type (breed.list)
    func fetchAllBreeds(of animal: AnimalType, completion: @escaping ([String]?, Error?) -> Void ) {
        let url = baseURL.appendingPathComponent("breed").appendingPathExtension("list")
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        let parameters = ["key": apiKey, "format": "json", "animal": animal.rawValue]
        
        let queryItems = parameters.compactMap { URLQueryItem(name: $0.key, value: $0.value) }
        urlComponents?.queryItems = queryItems
        
        guard let requestURL = urlComponents?.url else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod  = HTTPMethod.get.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching all breeds for animal type \(animal.rawValue): \(error)")
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
                let breedResults = try JSONDecoder().decode(BreedResults.self, from: data)
                completion(breedResults.breeds, nil)
            } catch {
                NSLog("Error decoding breeds list: \(error)")
                completion(nil, error)
                return
            }
        }.resume()
    }
    
    private let apiKey = "9f7c1e0f8917b3c9b4dc048aac580f92"
    private let baseURL = URL(string: "http://api.petfinder.com")!
}
