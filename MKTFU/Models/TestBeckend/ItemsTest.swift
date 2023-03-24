//
//  Items.swift
//  MKTFU
//
//  Created by mac on 2023-03-22.
//

import Foundation

// MARK: - ItemsTest
class ItemsTest: Codable {
    let status: String
    let error: [String]?
    let data: [ItemsDataTest]
    
    init() {
        self.status = ""
        self.error = [""]
        self.data = [ItemsDataTest]()
    }

    init(status: String, error: [String], data: [ItemsDataTest]) {
        self.status = status
        self.error = error
        self.data = data
    }
}

// MARK: - DatumTest
class ItemsDataTest: Codable {
    let itemID, name, price, detail: String
    let isSold: String
    let status: StatusTest
    let category: CategoryTest
    let user: UserTest
    let images: [ImageTest]
    
    init() {
        self.itemID = ""
        self.name = ""
        self.price = ""
        self.detail = ""
        self.isSold = ""
        self.status = StatusTest()
        self.category = CategoryTest()
        self.user = UserTest()
        self.images = [ImageTest]()
    }

    init(itemID: String, name: String, price: String, detail: String, isSold: String, status: StatusTest, category: CategoryTest, user: UserTest, images: [ImageTest]) {
        self.itemID = itemID
        self.name = name
        self.price = price
        self.detail = detail
        self.isSold = isSold
        self.status = status
        self.category = category
        self.user = user
        self.images = images
    }
}

// MARK: - CategoryTest
class CategoryTest: Codable {
    let categoryID, name, icon: String
    
    init() {
        self.categoryID = ""
        self.name = ""
        self.icon = ""
    }

    init(categoryID: String, name: String, icon: String) {
        self.categoryID = categoryID
        self.name = name
        self.icon = icon
    }
}

// MARK: - ImageTest
class ImageTest: Codable {
    let imageID, link, height, width: String
    
    init() {
        self.imageID = ""
        self.link = ""
        self.height = ""
        self.width = ""
    }

    init(imageID: String, link: String, height: String, width: String) {
        self.imageID = imageID
        self.link = link
        self.height = height
        self.width = width
    }
}

// MARK: - StatusTest
class StatusTest: Codable {
    let statusID, name: String
    
    init() {
        self.statusID = ""
        self.name = ""
    }

    init(statusID: String, name: String) {
        self.statusID = statusID
        self.name = name
    }
}

// MARK: - UserTest
class UserTest: Codable {
    let userID, firstName, lastName, email: String
    let phone, address: String
    let city: CityTest
    
    init() {
        self.userID = ""
        self.firstName = ""
        self.lastName = ""
        self.email = ""
        self.phone = ""
        self.address = ""
        self.city = CityTest()
    }

    init(userID: String, firstName: String, lastName: String, email: String, phone: String, address: String, city: CityTest) {
        self.userID = userID
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phone = phone
        self.address = address
        self.city = city
    }
}

// MARK: - CityTest
class CityTest: Codable {
    let cityID, name: String
    
    init() {
        self.cityID = ""
        self.name = ""
    }

    init(cityID: String, name: String) {
        self.cityID = cityID
        self.name = name
    }
}
