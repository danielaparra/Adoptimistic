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
        
        guard let userLocation = locationManager.location?.coordinate else { return }
        
        fetchPetsNear(userLocation: userLocation)
        
        let petMapAnn = PetMapAnnotation()
        petMapAnn.coordinate = userLocation
        mapView.addAnnotation(petMapAnn)
    }
    
    // MARK: - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        var mapRegion = MKCoordinateRegion()
        mapRegion.center = mapView.userLocation.coordinate
        mapRegion.span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        mapView.setRegion(mapRegion, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let petMapAnn = annotation as? PetMapAnnotation else { return nil }
        
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PetAnnotationView", for: petMapAnn) as! MKMarkerAnnotationView
        
        annotationView.glyphImage = UIImage(named: "Pets")
        annotationView.canShowCallout = true
        
        return annotationView
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    // MARK: - Private Methods
    
    private func fetchPetsNear(userLocation: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        
        getZipcodeFor(location: location) { (zipcode) in
            guard let zipcode = zipcode else { return }
            
            PetfinderClient.shared.findPets(near: zipcode) { (petResults, _, error) in
                if let error = error {
                    NSLog("Error finding pets: \(error)")
                    return
                }
                
                guard let petResults = petResults else { return }
                
                DispatchQueue.main.async {
                    let petMapAnn = PetMapAnnotation()
                    petMapAnn.coordinate = userLocation
                    self.mapView.addAnnotation(petMapAnn)
                }
                
            }
        }
    }
    
    private func getZipcodeFor(location: CLLocation, completion: @escaping (String?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                NSLog("Error fetching placemark for user location: \(error)")
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let pm = placemarks.first
            let zipcode = pm?.postalCode
            completion(zipcode)
        }
    }
    
    // MARK: - Properties
    
    var petController: PetController?
    
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    @IBOutlet weak var mapView: MKMapView!
}
