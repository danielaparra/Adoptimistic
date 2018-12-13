//
//  PetResultCollectionViewCell.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit
import CoreLocation

protocol PetResultCellDelegate: class {
    func didClickFavoriteButton(for cell: PetResultCollectionViewCell)
}

class PetResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Methods
    
    private func updatePetRepViews() {
        guard let petRep = petRep else { return }
        
        nameLabel.text = petRep.name
        let zipcode = NSNumber(value: (petRep.shelter?.zipcode)!)
        setMilesAwayLabel(from: zipcode.stringValue)
    }
    
    private func updatePetViews() {
        guard let pet = pet else { return }
        
        nameLabel.text = pet.name
        let zipcode = NSNumber(value: (pet.shelter?.zipcode)!)
        setMilesAwayLabel(from: zipcode.stringValue)
        
    }
    
    private func setMilesAwayLabel(from location: String) {
        guard let userLocation = userLocation else { return }
        
        getCoordinate(location: userLocation) { (coordinate2D, error) in
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            let userLocation = CLLocation(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
            
            self.getCoordinate(location: location) { (coordinate2D, error) in
                if let error = error {
                    NSLog("\(error)")
                    return
                }
                
                let petLocation = CLLocation(latitude: coordinate2D.latitude, longitude: coordinate2D.longitude)
                
                let distanceInMeters = userLocation.distance(from: petLocation)
                let distanceInMiles = round(distanceInMeters / 1609.344 * 100)/100
                
                self.milesLabel.text = "\(distanceInMiles) miles"
            }
        }
        
        
    }
    
    private func getCoordinate( location : String,
                                completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
    
    // MARK: - Properties
    
    var petRep: PetRepresentation? {
        didSet {
            updatePetRepViews()
        }
    }
    var pet: Pet? {
        didSet {
            updatePetViews()
        }
    }
    var userLocation: String?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var petDetailsView: UIView!
    
    weak var delegate: PetResultCellDelegate?
}
