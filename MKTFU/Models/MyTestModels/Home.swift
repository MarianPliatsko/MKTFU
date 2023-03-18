//
//  Home.swift
//  MKTFU
//
//  Created by mac on 2023-03-15.
//

import Foundation
import UIKit

class Home {
    var city: City //City is from CreateOffer Model
    var productCategory: [ProductCategory]
    var advertisementItems: [Items]
    
    init(city: City, productCategory: [ProductCategory], advertisementItems: [Items]) {
        self.city = city
        self.productCategory = productCategory
        self.advertisementItems = advertisementItems
    }
}

class ProductCategory {
    var name: String
    var image: UIImage
    
    init(name: String, image: UIImage) {
        self.name = name
        self.image = image
    }
}

class Items {
    var image: UIImage
    var name: String
    var price: String
    
    init(image: UIImage, name: String, price: String) {
        self.image = image
        self.name = name
        self.price = price
    }
}
