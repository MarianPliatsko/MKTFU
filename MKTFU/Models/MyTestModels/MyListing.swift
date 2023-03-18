//
//  MyListing.swift
//  MKTFU
//
//  Created by mac on 2023-03-17.
//

import Foundation
import UIKit

class MyList {
    var image: UIImage
    var date: Date
    var title: String
    var price: String
    var usedCondition: Bool
    
    init(image: UIImage, date: Date, name: String, price: String, usedCondition: Bool) {
        self.image = image
        self.date = date
        self.title = name
        self.price = price
        self.usedCondition = usedCondition
    }
}
