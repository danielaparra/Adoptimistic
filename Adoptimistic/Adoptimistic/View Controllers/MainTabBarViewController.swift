//
//  MainTabBarViewController.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import UIKit

protocol PetControllerProtocol {
    var petController: PetController? { get set }
}

class MainTabBarViewController: UITabBarController {
    
    // MARK: - Navigation

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for childVC in children {
            if let childVC = childVC as? UINavigationController {
                let firstChild = childVC.viewControllers.first
                if var child = firstChild as? PetControllerProtocol {
                    child.petController = petController
                }
            }
        }
    }

    private let petController = PetController()
}
