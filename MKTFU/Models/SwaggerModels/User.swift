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
    let streetAdress: String
    let city: String
    
    init() {
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phone = ""
        self.streetAdress = ""
        self.city = ""
    }
    
    init(userID: String, firstName: String, lastName: String, email: String, phone: String, adress: String, city: String) {
        self.id = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.streetAdress = adress
        self.city = city
    }
}
