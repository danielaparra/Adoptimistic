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
    
    @IBAction func addNoteAboutPet(_ sender: Any) {
        // Add alert controller
        let alert = UIAlertController(title: "Add a note", message: "By adding a note, you're saving this pet to favorites.", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = ""
        }
        
        let submitAction = UIAlertAction(title: "Save", style: .default) { (action) in
            guard let textField = alert.textFields?.first,
                let text = textField.text else { return }
            
            if self.pet == nil && text != "" {
                
                guard let petRep = self.petRep else { return }
                
                self.petController?.addPetToFavorites(petRep: petRep, notes: text)
                
            } else {
                guard let pet = self.pet else { return }
                
                self.petController?.updatePetInFavorites(pet: pet, notes: text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
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
        
        sizeLabel.text = petRep.size
        sexLabel.text = petRep.sex
        
        if let description = petRep.petDescription {
            descriptionTextView.text = description
        } else {
            descriptionTextView.text = "No description available."
        }
        
        //Add other details like options
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
            if breedsString != "" {
                breedsLabel.text = "Breed(s): \(breedsString)"
            } else {
                breedsLabel.text = "No breed specified"
            }
        } else {
            breedsLabel.text = "No breed specified"
        }
        
        switch size {
        case SizeType.small.rawValue:
            sizeLabel.text = "Small"
        case SizeType.medium.rawValue:
            sizeLabel.text = "Medium"
        case SizeType.large.rawValue:
            sizeLabel.text = "Large"
        case SizeType.extraLarge.rawValue:
            sizeLabel.text = "Extra Large"
        default:
            sizeLabel.text = ""
        }
        
        switch sex {
        case GenderType.f.rawValue:
            sexLabel.text = "Female"
        case GenderType.m.rawValue:
            sexLabel.text = "Male"
        default:
            sexLabel.text = ""
        }
        
        if let description = pet.petDescription {
            descriptionTextView.text = description
        } else {
            descriptionTextView.text = "No description available."
        }
        
        //Add other details like options
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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var previousPhotoButton: UIButton!
    @IBOutlet weak var nextPhotoButton: UIButton!
    
}
