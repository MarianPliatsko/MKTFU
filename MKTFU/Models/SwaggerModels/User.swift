//
//  User.swift
//  MKTFU
//
//  Created by mac on 2023-02-27.
//

import Foundation

class User: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phone: String
    let address: String
    let city: String
    
    init() {
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phone = ""
        self.address = ""
        self.city = ""
    }
    
    init(userID: String, firstName: String, lastName: String, email: String, phone: String, address: String, city: String) {
        self.id = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.address = address
        self.city = city
    }
}
