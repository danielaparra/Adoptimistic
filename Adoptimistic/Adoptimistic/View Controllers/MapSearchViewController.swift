//
//  MapSearchViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController, MKMapViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PetAnnotationView")
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addSubview(userTrackingButton)
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 0).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0).isActive = true
        
        fetchPetsNearMe()
    }
    


    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Private Methods
    
    private func fetchPetsNearMe() {
        PetfinderClient.shared.findPets(near: "21742") { (petResults, error) in
            if let error = error {
                NSLog("Error finding pets: \(error)")
                return
            }
            
            guard let petResults = petResults else { return }
            
            for pet in petResults {
                PetfinderClient.shared.findShelter(byID: pet.shelterId, completion: { (shelterRep, error) in
                    pet.shelter = shelterRep
                    self.mapView.addAnnotation(pet)
                })
            }
        }
    }
    
    // MARK: - Properties
    
    private var petNearbyResults: [PetRepresentation]? {
        didSet {
            
        }
    }
    
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    @IBOutlet weak var mapView: MKMapView!
}
