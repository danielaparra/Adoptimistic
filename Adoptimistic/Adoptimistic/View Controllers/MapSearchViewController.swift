//
//  MapSearchViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import MapKit

class MapSearchViewController: UIViewController, MKMapViewDelegate, PetControllerProtocol, DetailAnnotationViewDelegate {
    
    func didClickViewPetsButton(on detailAnnotationView: MapPetDetailAnnotationView) {
        guard let petMapAnn = detailAnnotationView.petMapAnn else { return }
        
        print(petMapAnn.title ?? "No title")
        
        
    }
    

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
        
        let detailView = MapPetDetailAnnotationView(frame: .zero)
        detailView.petMapAnn = petMapAnn
        detailView.delegate = self
        
        annotationView.detailCalloutAccessoryView = detailView
        
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
                self.sort(petResults: petResults)
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
    
    private func getCoordinateFor(contact: PetRepresentation.Contact, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        
        var location = ""
        if let address = contact.address {
            location = address
        }
        location += "\(contact.city), \(contact.state) \(contact.zipcode)"
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location, in: nil, preferredLocale: nil) { (placemarks, error) in
            if let error = error {
                NSLog("Error fetching placemarks for zipcode: \(error)")
                return
            }
            
            guard let placemarks = placemarks,
                let pm = placemarks.first,
                let location = pm.location else { return }
            
            completion(location.coordinate)
            return
        }
    }
    
    private func sort(petResults: [PetRepresentation]){
        
        let setOfContacts = Set(petResults.compactMap { $0.contact })
        
        var arrayOfMapAnns = [PetMapAnnotation]()
        
        let group = DispatchGroup()
        for contact in setOfContacts {
            group.enter()
            getCoordinateFor(contact: contact) { (coordinate) in
                guard let coordinate = coordinate else { return }
                
                let contactRep = ContactRepresentation(city: contact.city, address: contact.address, state: contact.state, zipcode: contact.zipcode, phone: contact.phone, email: contact.email)
                let mapAnn = PetMapAnnotation(contact: contactRep, coordinate: coordinate)
                arrayOfMapAnns.append(mapAnn)
                group.leave()
            }
        }
        group.wait()
        
        for petResult in petResults {
            for mapAnn in arrayOfMapAnns {
                
                let contact = petResult.contact
                guard let mapContact = mapAnn.contact else {return}
                if contact.city == mapContact.city &&
                contact.address == mapContact.address &&
                contact.zipcode == mapContact.zipcode &&
                    contact.state == mapContact.state {
                    mapAnn.petReps.append(petResult)
                }
            }
        }
        
        mapView.addAnnotations(arrayOfMapAnns)
    }
    
    // MARK: - Properties
    
    var petController: PetController?
    
    private let operationQueue = OperationQueue()
    private let locationManager = CLLocationManager()
    private var userTrackingButton: MKUserTrackingButton!
    
    @IBOutlet weak var mapView: MKMapView!
}
