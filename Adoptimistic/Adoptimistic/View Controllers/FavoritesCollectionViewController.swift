//
//  FavoritesCollectionViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation

class FavoritesCollectionViewController: UICollectionViewController, PetControllerProtocol, NSFetchedResultsControllerDelegate, CLLocationManagerDelegate {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                self.currentUserLocation = zipcode
            }
        }
        
        collectionView.reloadData()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetFaveCell", for: indexPath) as? PetResultCollectionViewCell ?? PetResultCollectionViewCell()
    
        let pet = fetchedResultsController.object(at: indexPath)
        cell.pet = pet
        cell.userLocation = currentUserLocation
    
        return cell
    }
    
    // MARK: - Properties
    
    var petController: PetController?
    lazy var fetchedResultsController: NSFetchedResultsController<Pet> = {
        let fetchRequest: NSFetchRequest<Pet> = Pet.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        let moc = CoreDataStack.shared.mainContext
        
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        try! frc.performFetch()
        return frc
    }()

    private var currentUserLocation: String? {
        didSet{
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private let locationManager = CLLocationManager()
}
