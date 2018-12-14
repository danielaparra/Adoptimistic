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
    
    
    
    @IBAction func clickFavoriteButton(_ sender: Any) {
        guard let isFavorite = isFavorite else { return }
        
        if isFavorite == false {
            favoriteButton.setImage(UIImage(named: "Favorite" ), for: .normal)
            delegate?.didClickFavoriteButton(for: self)
            self.isFavorite = true
        } else {
            favoriteButton.setImage(UIImage(named: "Unfavorite"), for: .normal)
            delegate?.didClickFavoriteButton(for: self)
            self.isFavorite = false
        }
    }
    
    // MARK: - Private Methods
    
    private func updatePetRepViews() {
        guard let petRep = petRep,
            let photoURL = petRep.photos.first else { return }
    
        PetfinderClient.shared.fetchImageDataFromURL(urlString: photoURL) { (data, error) in
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
        }
        
        nameLabel.text = petRep.name
    
        setMilesAwayLabel(from: petRep.contact.zipcode)
    }
    
    private func updatePetViews() {
        guard let pet = pet,
            let photos = pet.photos,
            let photoURL = photos.first,
            let contact = pet.contact,
            let zipcode = contact.zipcode else { return }
        
        PetfinderClient.shared.fetchImageDataFromURL(urlString: photoURL) { (data, error) in
            if let error = error {
                NSLog("\(error)")
                return
            }
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                self.photoImageView.image = UIImage(data: data)
            }
        }
        
        nameLabel.text = pet.name
    
        setMilesAwayLabel(from: zipcode)
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
                
                DispatchQueue.main.async {
                    if distanceInMeters < 1609.344 {
                        self.milesLabel.text = "< 1 mile away"
                    } else {
                        self.milesLabel.text = "\(distanceInMiles) miles away"
                    }
                }
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
    var isFavorite: Bool?
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var petDetailsView: UIView!
    
    weak var delegate: PetResultCellDelegate?
}
