//
//  PetSearchCollectionViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

class PetSearchCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func searchForPets(_ sender: Any) {
        
        if moreDetailsIsHidden {
            guard let zipcode = zipcodeTextField.text else { return }
            
            let animalText = animalTextField.text
            
            var animal: AnimalType?
            switch animalText {
            case AnimalType.barnYard.rawValue:
                animal = AnimalType.barnYard
            case AnimalType.bird.rawValue:
                animal = AnimalType.bird
            case AnimalType.cat.rawValue:
                animal = AnimalType.cat
            case AnimalType.dog.rawValue:
                animal = AnimalType.dog
            case AnimalType.horse.rawValue:
                animal = AnimalType.horse
            case AnimalType.rabbit.rawValue:
                animal = AnimalType.rabbit
            case AnimalType.reptile.rawValue:
                animal = AnimalType.reptile
            case AnimalType.smallFurry.rawValue:
                animal = AnimalType.smallFurry
            default:
                animal = nil
            }
            
            PetfinderClient.shared.findPets(near: zipcode, animal: animal) { (petResults, error) in
                if let error = error {
                    NSLog("Error finding pets: \(error)")
                    return
                }
                
                self.petSearchResults = petResults
            }
        } else {
            //more details
        }
    }
    
    @IBAction func findMorePets(_ sender: Any) {
    }
    
    @IBAction func addMoreDetails(_ sender: Any) {
        
        if moreDetailsIsHidden {
            moreDetailsStackView.isHidden = false
            moreDetailsButton.setTitle("Show less details", for: .normal)
        } else {
            moreDetailsStackView.isHidden = true
            moreDetailsButton.setTitle("+ more details", for: .normal)
        }
    }
    
    // MARK: - UICollectionViewDatasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return petSearchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PetResultCell", for: indexPath)
        
        //Configure cell
        
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ViewPetResult" {
            
        }
    }
    
    // MARK: - Private Methods
    
    private func updateViews() {
        
    }
    
    // MARK: - Properties
    
    private var petSearchResults: [PetRepresentation]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    private var offset: String?
    private var moreDetailsIsHidden = true
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var animalTextField: UITextField!
    @IBOutlet weak var moreDetailsStackView: UIStackView!
    @IBOutlet weak var moreDetailsButton: UIButton!
    
}
