//
//  MapPetDetailAnnotationView.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/13/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol DetailAnnotationViewDelegate: class {
    func didClickViewPetsButton(on detailAnnotationView: MapPetDetailAnnotationView)
}

class MapPetDetailAnnotationView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let imageHeightConstraint = NSLayoutConstraint(item: locationImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        let imageWidthConstraint = NSLayoutConstraint(item: locationImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        NSLayoutConstraint.activate([imageWidthConstraint, imageHeightConstraint])
        locationImageView.contentMode = .scaleAspectFit
        
        let locationStackView = UIStackView(arrangedSubviews: [locationImageView, locationLabel])
        locationStackView.axis = .horizontal
        let mainStackView = UIStackView(arrangedSubviews: [locationStackView, address1Label, address2Label, viewPetsButton])
        mainStackView.axis = .vertical
        mainStackView.spacing = UIStackView.spacingUseSystem
        
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainStackView)
        mainStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        mainStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        mainStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func clickViewPets(_ sender: UIButton) {
        delegate?.didClickViewPetsButton(on: self)
    }
    
    private func updateSubviews() {
        guard let petMapAnn = petMapAnn,
            let contact = petMapAnn.contact else { return }
        
        locationImageView.image = UIImage(named: "Location")
        locationLabel.text = "Location"
        
        if let address = contact.address {
            address1Label.text = address
        } else {
            address1Label.isHidden = true
        }
        
        let city = contact.city
        let state = contact.state
        let zipcode = contact.zipcode
        address2Label.text = "\(city), \(state) \(zipcode)"
        
        viewPetsButton.setTitle("View pets from this location", for: .normal)
    }
    
    var petMapAnn: PetMapAnnotation? {
        didSet {
            updateSubviews()
        }
    }
    weak var delegate: DetailAnnotationViewDelegate?
    
    private let locationImageView = UIImageView()
    private let locationLabel = UILabel()
    private let address1Label = UILabel()
    private let address2Label = UILabel()
    private let viewPetsButton = UIButton(type: UIButton.ButtonType.roundedRect)
}
