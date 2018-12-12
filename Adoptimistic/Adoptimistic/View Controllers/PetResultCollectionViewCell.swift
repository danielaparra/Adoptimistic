//
//  PetResultCollectionViewCell.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol PetResultCellDelegate: class {
    func didClickFavoriteButton(for cell: PetResultCollectionViewCell)
}

class PetResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Methods
    
    private func updatePetRepViews() {
        guard let petRep = petRep else { return }
        
        nameLabel.text = petRep.name
    }
    
    private func updatePetViews() {
        guard let pet = pet else { return }
        
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
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breedLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var petDetailsView: UIView!
    
    weak var delegate: PetResultCellDelegate?
}
