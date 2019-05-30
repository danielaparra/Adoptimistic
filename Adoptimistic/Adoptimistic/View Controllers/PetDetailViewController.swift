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
            if breeds.count == 1 {
                breedsLabel.text = "Breed: \(breeds.first ?? "No breed")"
            } else {
                let breedsString = breeds.joined(separator: ", ")
                breedsLabel.text = "Breeds: \(breedsString)"
            }
        } else {
            breedsLabel.text = "No breed specified"
        }
        
        sizeLabel.text = determine(size: petRep.size)
        sexLabel.text = determine(gender: petRep.sex)
        descriptionTextView.text = determine(description: petRep.petDescription)
        
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
            if breeds.count == 1 {
                breedsLabel.text = "Breed: \(breeds.first ?? "No breed")"
            } else {
                let breedsString = breeds.joined(separator: ", ")
                breedsLabel.text = "Breeds: \(breedsString)"
            }
        } else {
            breedsLabel.text = "No breed specified"
        }
        
        sizeLabel.text = determine(size: size)
        sexLabel.text = determine(gender: sex)
        descriptionTextView.text = determine(description: description)
        
        //Add other details like options
    }
    
    // MARK - Private Methods
    
    private func determine(gender: String) -> String {
        switch gender {
        case GenderType.f.rawValue:
            return "Female"
        case GenderType.m.rawValue:
            return "Male"
        default:
            return "No gender specified"
        }
    }
    
    private func determine(size: String) -> String {
        switch size {
        case SizeType.small.rawValue:
            return "Small"
        case SizeType.medium.rawValue:
            return "Medium"
        case SizeType.large.rawValue:
            return "Large"
        case SizeType.extraLarge.rawValue:
            return "Extra Large"
        default:
            return "No size specified"
        }
    }
    
    private func determine(description: String?) -> String {
        if let description = description {
            return description
        } else {
            return "No description available."
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
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var previousPhotoButton: UIButton!
    @IBOutlet weak var nextPhotoButton: UIButton!
    
}
