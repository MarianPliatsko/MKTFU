//
//  ProoductDetail.swift
//  MKTFU
//
//  Created by mac on 2023-03-09.
//

import Foundation

class Product: Codable {
    let id: String
    let title: String
    let description: String
    let address: String
    let city: String
    let created: String
    let price: Int
    let userID: String
    
    init() {
        self.id = ""
        self.title = ""
        self.description = ""
        self.address = ""
        self.city = ""
        self.created = ""
        self.price = 0
        self.userID = ""
    }
    
    init(id: String, title: String, description: String, address: String, city: String, created: String, price: Int, userID: String) {
        self.id = id
        self.title = title
        self.description = description
        self.address = address
        self.city = city
        self.created = created
        self.price = price
        self.userID = userID
    }
}
