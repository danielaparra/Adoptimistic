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
        guard let petRep = petRep, isViewLoaded else { return }
        
        nameLabel.text = petRep.name
    }
    
    private func updatePetViews() {
        guard let pet = pet, isViewLoaded else { return }
        
        nameLabel.text = pet.name
        //breedLabel.text = pet.breeds?.first
        
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
