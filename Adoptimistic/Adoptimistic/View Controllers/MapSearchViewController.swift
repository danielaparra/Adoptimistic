//
//  MapSearchViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController, MKMapViewDelegate, PetControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "PetAnnotationView")
        userTrackingButton = MKUserTrackingButton(mapView: mapView)
        userTrackingButton.translatesAutoresizingMaskIntoConstraints = false
        
        mapView.addSubview(userTrackingButton)
        userTrackingButton.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 0).isActive = true
        userTrackingButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 0).isActive = true
        
        fetchPetsNearMe()
    }
    
    // MARK: - MKMapView
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        mapView.setRegion(mapRegion, animated: true)
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Private Methods
    
    private func fetchPetsNearMe() {
        PetfinderClient.shared.findPets(near: "94107") { (petResults, error) in
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
    
    var petController: PetController?
    
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    @IBOutlet weak var mapView: MKMapView!
}
