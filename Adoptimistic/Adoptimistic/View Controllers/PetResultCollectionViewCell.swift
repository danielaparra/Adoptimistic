//
//  PetResultCollectionViewCell.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol PetResultCellDelegate {
    func didClickFavoriteButton(for cell: PetResultCollectionViewCell)
}

class PetResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Methods
    
    private func updateViews() {
        guard let pet = pet else { return }
        
        nameLabel.text = pet.name
    }
    
    // MARK: - Properties
    
    var pet: PetRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var petDetailsView: UIView!
    
    weak var delegate: PetSearchCollectionViewController?
}
