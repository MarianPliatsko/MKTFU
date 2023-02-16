//
//  Category.swift
//  MKTFU
//
//  Created by mac on 2023-02-13.
//

import Foundation

struct CategoryContainer: Decodable {
    let records: [CategoryModel]
}

struct CategoryModel: Decodable {
    let categoryId: Int
    let displaySaquence: Int
    let categoryName: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case categoryId = "cid"
        case displaySaquence = "seq"
        case categoryName = "name"
        case imageUrl = "img"
    }
}
