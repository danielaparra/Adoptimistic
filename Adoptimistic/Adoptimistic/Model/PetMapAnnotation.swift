//
//  PetMapAnnotation.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/13/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import MapKit

class PetMapAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var petReps: [PetRepresentation]
    var title: String?
    var subtitle: String? {
        return "\(petReps.count) pets"
    }
    
    required override init() {
        self.petReps = []
        self.coordinate = CLLocationCoordinate2D()
        self.title = "Title"
    }
}
