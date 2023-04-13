//
//  ProoductDetail.swift
//  MKTFU
//
//  Created by mac on 2023-03-09.
//

import Foundation

enum Categories: String, Codable {
    case deals = "DEALS"
    case realEstate = "REAL_ESTATE"
    case vehicles = "VEHICLES"
    case furniture = "FURNITURE"
    case electronics = "ELECTRONICS"
    var localizedTitle: String {
        switch self {
        case .deals:
            return "Deals"
        case .realEstate:
            return "Real estate"
        case .vehicles:
            return "Vehicles"
        case .furniture:
            return "Furniture"
        case .electronics:
            return "Electronics"
        }
    }
}

enum Conditions: String, Codable {
    case new = "NEW"
    case used = "USED"
    var localizedTitle: String {
        switch self {
        case .new:
            return "New"
        case .used:
            return "Used"
        }
    }
}

struct Product: Codable {
    var id, productName, description: String
    var price: Double
    var category: Categories?
    var condition: Conditions?
    var status, address: String
    var city: String
    var sellerListingCount: Int?
    var created: String
    var userId: String
    var sellerProfile: SellerProfile?
    var images: [String]
    
    init(id: String? = nil, productName: String? = nil, description: String? = nil, price: Double? = nil, category: Categories? = nil, condition: Conditions? = nil, status: String? = nil, address: String? = nil, city: String? = nil, sellerListingCount: Int? = nil, created: String? = nil, userId: String? = nil, sellerProfile: SellerProfile? = nil, images: [String]? = nil) {
        self.id = id ?? ""
        self.productName = productName ?? ""
        self.description = description ?? ""
        self.price = price ?? 0.0
        self.category = category
        self.condition = condition
        self.status = status ?? ""
        self.address = address ?? ""
        self.city = city ?? ""
        self.sellerListingCount = sellerListingCount
        self.created = created ?? ""
        self.userId = userId ?? ""
        self.sellerProfile = sellerProfile
        self.images = images ?? []
    }
}

// MARK: - SellerProfile
struct SellerProfile: Codable {
    var id, firstName, lastName, email: String
    var phone, address, city: String
}
