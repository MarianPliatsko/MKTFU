//
//  CreateOffer.swift
//  MKTFU
//
//  Created by mac on 2023-03-03.
//

import Foundation
import UIKit

struct CreateOffer {
    let category: Category
    let condition: Condition
    let city: City
}

struct Category {
    let categoryList: [String]
}

struct Condition {
    let conditionList: [String]
}
