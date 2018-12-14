//
//  ContactRepresentation.swift
//  Adoptimistic
//
//  Created by Daniela Parra on 12/14/18.
//  Copyright © 2018 Daniela Parra. All rights reserved.
//

import Foundation

class ContactRepresentation: NSObject {
    let city: String
    let address: String?
    let state: String
    let zipcode: String
    let phone: String?
    let email: String?
    
    init(city: String, address: String?, state: String, zipcode: String, phone:String?, email: String?) {
        self.city = city
        self.address = address
        self.state = state
        self.zipcode = zipcode
        self.phone = phone
        self.email = email
    }
}
