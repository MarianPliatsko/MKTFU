//
//  CreateOffer.swift
//  MKTFU
//
//  Created by mac on 2023-03-03.
//

import Foundation
import UIKit

class CreateOffer {
    var images: [UIImage]
    let productName: [String]
    let description: String
    let category: Category
    let condition: Condition
    let price: Double
    let adress: String
    let city: City
    var isShow: Bool
    
    init() {
        self.images = []
        self.productName = []
        self.description = "description"
        self.category = Category()
        self.condition = Condition()
        self.price = 0.00
        self.adress = ""
        self.city = City()
        self.isShow = false
    }
    
    init(images:[UIImage], productName: [String], description: String, category: Category, condition: Condition, price: Double, adress: String, city: City, isShow: Bool) {
        self.images = images
        self.productName = productName
        self.description = description
        self.category = category
        self.condition = condition
        self.price = price
        self.adress = adress
        self.city = city
        self.isShow = isShow
    }
}

class Category {
    let categoryName: String
    let categotyLblPlaceholder: String
    let categoryList: [String]
    
    init() {
        self.categoryName = ""
        self.categotyLblPlaceholder = ""
        self.categoryList = []
    }
    
    init(categoryName: String, categotyLblPlaceholder: String, categoryList: [String]) {
        self.categoryName = categoryName
        self.categotyLblPlaceholder = categotyLblPlaceholder
        self.categoryList = categoryList
    }
}

class Condition {
    let conditionName: String
    let conditionLblPlaceholder: String
    let conditionList: [String]
    
    init() {
        self.conditionName = ""
        self.conditionLblPlaceholder = ""
        self.conditionList = []
    }
    
    init(conditionName: String, conditionLblPlaceholder: String, conditionList: [String]) {
        self.conditionName = conditionName
        self.conditionLblPlaceholder = conditionLblPlaceholder
        self.conditionList = conditionList
    }
}
