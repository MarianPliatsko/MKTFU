//
//  Home.swift
//  MKTFU
//
//  Created by mac on 2023-03-15.
//

import Foundation
import UIKit

class Home {
    var city: City
    var productCategory: [ProductCategory]
    
    init(city: City, productCategory: [ProductCategory]) {
        self.city = city
        self.productCategory = productCategory
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
