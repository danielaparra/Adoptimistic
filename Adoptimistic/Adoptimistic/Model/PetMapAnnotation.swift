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
    var title: String? {
        return "\(petReps.count) pets"
    }
//    var subtitle: String? {
//        guard let contact = contact else { return nil }
//        return "\(contact.city), \(contact.state)"
//    }
    let contact: ContactRepresentation?
    
    init(contact: ContactRepresentation, coordinate: CLLocationCoordinate2D) {
        
        self.petReps = []
        self.coordinate = coordinate
        self.contact = contact
    }
}
