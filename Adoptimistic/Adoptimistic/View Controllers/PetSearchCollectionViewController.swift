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
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func getCurrentLocation(_ sender: Any) {
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
        
        guard let zipcode = zipcodeTextField.text else { return }
        
        let animalText = animalTextField.text
        
        var animal: AnimalType?
        switch animalText {
        case AnimalType.barnYard.rawValue:
            animal = AnimalType.barnYard
        case AnimalType.bird.rawValue:
            animal = AnimalType.bird
        case AnimalType.cat.rawValue:
            animal = AnimalType.cat
        case AnimalType.dog.rawValue:
            animal = AnimalType.dog
        case AnimalType.horse.rawValue:
            animal = AnimalType.horse
        case AnimalType.rabbit.rawValue:
            animal = AnimalType.rabbit
        case AnimalType.reptile.rawValue:
            animal = AnimalType.reptile
        case AnimalType.smallFurry.rawValue:
            animal = AnimalType.smallFurry
        default:
            animal = nil
        }
        
        var breed: String?
        var size: SizeType?
        var sex: GenderType?
        var age: AgeType?
        
        if !moreDetailsIsHidden {
           //change them here according to details tab
        }
        
        PetfinderClient.shared.findPets(near: zipcode, animal: animal, breed: breed, size: size, sex: sex, age: age) { (petResults, lastOffset, error) in
            if let error = error {
                NSLog("Error finding pets: \(error)")
                return
            }
            
            guard let petResults = petResults,
                let lastOffset = lastOffset else { return }
            
            self.petSearchResults = petResults
            self.offset = lastOffset
            self.savedLocation = zipcode
            self.animal = animal
            self.breed = breed
            self.size = size
            self.sex = sex
            self.age = age
            
            DispatchQueue.main.async {
                self.loadMoreButton.isHidden = false
            }
        }
    }
    
    @IBAction func findMorePets(_ sender: Any) {
        guard let savedLocation = savedLocation else { return }
        
        PetfinderClient.shared.findPets(near: savedLocation, animal: animal, breed: breed, size: size, sex: sex, age: age, offset: offset) { (petResults, lastOffset, error) in
            if let error = error {
                NSLog("Error finding pets: \(error)")
                return
            }
            
            guard let petResults = petResults,
                let lastOffset = lastOffset else { return }
            
            self.offset = lastOffset
            self.petSearchResults?.append(contentsOf: petResults)
        }
    }
    
    @IBAction func addMoreDetails(_ sender: Any) {
        
        if moreDetailsIsHidden {
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
    
    // MARK: - Properties
    
    var petController: PetController?
    private var petSearchResults: [PetRepresentation]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var moreDetailsIsHidden = true
    private var savedLocation: String?
    private var animal: AnimalType?
    private var breed: String?
    private var size: SizeType?
    private var sex: GenderType?
    private var age: AgeType?
    private var offset: String?
    private var locationManager = CLLocationManager()
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var animalTextField: UITextField!
    @IBOutlet weak var moreDetailsStackView: UIStackView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    @IBOutlet weak var loadMoreButton: UIButton!
    
}
