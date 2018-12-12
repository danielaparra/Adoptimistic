//
//  PetRepresentation+Mapping.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/11/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation
import MapKit

extension PetRepresentation: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: shelter?.latitude ?? 0.0, longitude: shelter?.longitude ?? 0.0)
    }
}
