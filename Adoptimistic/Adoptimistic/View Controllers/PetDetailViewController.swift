//
//  PetDetailViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class PetDetailViewController: UIViewController, PetControllerProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        if pet != nil {
            updatePetViews()
            return
        } else if petRep != nil {
            updatePetRepViews()
            return
        }
    }
    
    @IBAction func pressForPreviousPhoto(_ sender: Any) {
        
    }
    
    @IBAction func pressForNextPhoto(_ sender: Any) {
    }
    
    // MARK: - Private Methods
    
    private func updatePetRepViews() {
        guard let petRep = petRep, isViewLoaded,
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
        if let breeds = petRep.breeds {
            let breedsString = breeds.joined(separator: ", ")
            breedsLabel.text = "Breed(s): \(breedsString)"
        } else {
            breedsLabel.text = "No breed specified"
        }
    }
    
    private func updatePetViews() {
        
        guard let pet = pet, isViewLoaded,
            let photos = pet.photos,
            let photoURL = photos.first,
            let contact = pet.contact,
            let zipcode = contact.zipcode,
            let size = pet.size,
            let sex = pet.sex else { return }
        
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
        
        if contact.city != nil && contact.state != nil {
            distanceLabel.text = "\(contact.city!), \(contact.state!)"
        } else {
            distanceLabel.text = "\(zipcode)"
        }
        
        if let breeds = pet.breeds {
            let breedsString = breeds.joined(separator: ", ")
            breedsLabel.text = "Breed(s): \(breedsString)"
        } else {
            breedsLabel.text = "No breed specified"
        }
        
        sizeLabel.text = size
        sexLabel.text = sex
        
        if let description = pet.petDescription {
            descriptionLabel.text = description
        } else {
            descriptionLabel.text = "No description available."
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
    
    var petController: PetController?
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var breedsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var notesTextView: UITextView!
    @IBOutlet weak var previousPhotoButton: UIButton!
    @IBOutlet weak var nextPhotoButton: UIButton!
    
}
