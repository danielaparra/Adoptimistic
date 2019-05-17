//
//  PetSearchCollectionViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreLocation

class PetSearchCollectionViewController: UIViewController, PetControllerProtocol, UICollectionViewDataSource, UICollectionViewDelegate, CLLocationManagerDelegate, PetResultCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    // MARK: - PetResultCellDelegate
    
    func didClickFavoriteButton(for cell: PetResultCollectionViewCell) {
        guard let petRep = cell.petRep,
            let isFavorite = petRep.isFavorite else { return }
        
        if !isFavorite {
            petController?.addPetToFavorites(petRep: petRep)
            petRep.isFavorite = true
        } else {
            //find pet equal to pet rep
            
            //remove pet from favorites
            petRep.isFavorite = false
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func getCurrentLocation(_ sender: Any) {
        let locationManager = CLLocationManager()
        let geocoder = CLGeocoder()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        guard let latitude = locationManager.location?.coordinate.latitude,
            let longitude = locationManager.location?.coordinate.longitude else { return }
        
        let userLocation = CLLocation(latitude: latitude, longitude: longitude)
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if let error = error {
                NSLog("Error fetching placemark for user location: \(error)")
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let pm = placemarks.first
            let zipcode = pm?.postalCode
            DispatchQueue.main.async {
                self.zipcodeTextField.text = zipcode
            }
        }
    }
    
    @IBAction func searchForPets(_ sender: Any) {
        
        // Unwrap text from text fields.
        guard let zipcode = zipcodeTextField.text,
            let animalText = animalTextField.text,
            let breedText = breedTextField.text else {
                // TODO: Account for if user enters no zipcode or no animal or no breed
                return
        }
        
        // Confirm which details have been added to the search request.
        let animal = confirmAnimalType(animalText: animalText)
        let breed = confirmBreedType(breedText: breedText, for: animal)
        let size = confirmSize()
        let sex = confirmGenderType()
        let age = confirmAgeType()
        
        // Call Petfinder client to make search request.
        PetfinderClient.shared.findPets(near: zipcode, animal: animal, breed: breed, size: size, sex: sex, age: age) { (petResults, lastOffset, error) in
            if let error = error {
                NSLog("Error finding pets: \(error)")
                return
            }
            
            guard let petResults = petResults,
                let lastOffset = lastOffset else { return }
            
            // Set pet search results and other details to load more results later.
            self.petSearchResults = petResults
            self.offset = lastOffset
            self.savedLocation = zipcode
            self.animal = animal
            self.breed = breed
            self.size = size
            self.sex = sex
            self.age = age
            
            // Display load more button.
            DispatchQueue.main.async {
                self.loadMoreButton.isHidden = false
            }
        }
    }
    
    @IBAction func findMorePets(_ sender: Any) {
        
        guard let savedLocation = savedLocation else { return }
        
        // Call Petfinder client to find more pets from passed in offset value.
        PetfinderClient.shared.findPets(near: savedLocation, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: offset) { (petResults, lastOffset, error) in
            if let error = error {
                NSLog("Error finding pets: \(error)")
                return
            }
            
            guard let petResults = petResults,
                let lastOffset = lastOffset else { return }
            
            // Update pet search results and offset value.
            self.offset = lastOffset
            self.petSearchResults?.append(contentsOf: petResults)
        }
    }
    
    // Update more details stack view and button according to user interaction.
    @IBAction func addMoreDetails(_ sender: Any) {
        if moreDetailsStackView.isHidden {
            moreDetailsStackView.isHidden = false
            moreDetailsButton.setTitle("Show less details", for: .normal)
        } else {
            moreDetailsStackView.isHidden = true
            moreDetailsButton.setTitle("+ more details", for: .normal)
        }
    }
    
    // MARK: - UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petSearchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetResultCell", for: indexPath) as?  PetResultCollectionViewCell ?? PetResultCollectionViewCell()
        
        let petRep = petSearchResults?[indexPath.row]
        if petRep?.isFavorite == nil {
            petRep?.isFavorite = false
        }
        cell.petRep = petRep
        
        //Should this be a CLLocation already? Maybe not for every case
        cell.userLocation = savedLocation
        
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPet" {
            guard let destinationVC = segue.destination as? PetDetailViewController,
                let indexPath = collectionView.indexPathsForSelectedItems?.first else { return }
            let petRep = petSearchResults?[indexPath.row]
            destinationVC.petRep = petRep
            destinationVC.petController = petController
        }
    }
    
    // MARK - Private Methods
    
    private func confirmAnimalType(animalText: String) -> AnimalType? {
        
        switch animalText {
        case AnimalType.barnYard.rawValue:
            return AnimalType.barnYard
        case AnimalType.bird.rawValue:
            return AnimalType.bird
        case AnimalType.cat.rawValue:
            return AnimalType.cat
        case AnimalType.dog.rawValue:
            return AnimalType.dog
        case AnimalType.horse.rawValue:
            return AnimalType.horse
        case AnimalType.rabbit.rawValue:
            return AnimalType.rabbit
        case AnimalType.reptile.rawValue:
            return AnimalType.reptile
        case AnimalType.smallFurry.rawValue:
            return AnimalType.smallFurry
        default:
            return nil
        }
    }
    
    private func confirmBreedType(breedText: String, for animal: AnimalType?) -> String? {
        // TODO: Check through breed list to find breeds for animal
        switch animal {
        
        default:
            return nil
        }
    }
    
    private func confirmSize() -> SizeType? {
        switch sizeSegmentedControl.selectedSegmentIndex {
        case 0:
            return SizeType.small
        case 1:
            return SizeType.medium
        case 2:
            return SizeType.large
        case 3:
            return SizeType.extraLarge
        default:
            return nil
        }
    }
    
    private func confirmGenderType() -> GenderType? {
        switch sexSegmentedControl.selectedSegmentIndex {
        case 0:
            return GenderType.m
        case 1:
            return GenderType.f
        default:
            return nil
        }
    }
    
    private func confirmAgeType() -> AgeType? {
        switch ageSegmentedControl.selectedSegmentIndex {
        case 0:
            return AgeType.baby
        case 1:
            return AgeType.young
        case 2:
            return AgeType.adult
        case 3:
            return AgeType.senior
        default:
            return nil
        }
    }
    
    // MARK: - Properties
    
    var petController: PetController?
    private var petSearchResults: [PetRepresentation]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    private var savedLocation: String?
    private var animal: AnimalType?
    private var breed: String?
    private var size: SizeType?
    private var sex: GenderType?
    private var age: AgeType?
    private var offset: String?
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var animalTextField: UITextField!
    @IBOutlet weak var moreDetailsStackView: UIStackView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var breedTextField: UITextField!
    @IBOutlet weak var sexSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sizeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var ageSegmentedControl: UISegmentedControl!
    
}
