//
//  ProoductDetail.swift
//  MKTFU
//
//  Created by mac on 2023-03-09.
//

import Foundation

enum Categories: String, Codable {
    case dealsGET = "DEALS"
    case realEstateGET = "REAL_ESTATE"
    case vehiclesGET = "VEHICLES"
    case furnitureGET = "FURNITURE"
    case electronicsGET = "ELECTRONICS"
    case dealsPOST = "Deals"
    case realEstatePOST = "Real estate"
    case vehiclesPOST = "Vehicles"
    case furniturePOST = "Furniture"
    case electronicsPOST = "Electronics"
    var localizedTitle: String {
        switch self {
        case .dealsGET:
            return "Deals"
        case .realEstateGET:
            return "Real estate"
        case .vehiclesGET:
            return "Vehicles"
        case .furnitureGET:
            return "Furniture"
        case .electronicsGET:
            return "Electronics"
        case .dealsPOST:
            return "DEALS"
        case .realEstatePOST:
            return "REAL_ESTATE"
        case .vehiclesPOST:
            return "VEHICLES"
        case .furniturePOST:
            return "FURNITURE"
        case .electronicsPOST:
            return "ELECTRONICS"
        }
    }
}

enum Conditions: String, Codable {
    case newGET = "NEW"
    case usedGET = "USED"
    case newPOST = "New"
    case usedPOST = "Used"
    var localizedTitle: String {
        switch self {
        case .newGET:
            return "New"
        case .usedGET:
            return "Used"
        case .newPOST:
            return "NEW"
        case .usedPOST:
            return "USED"
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
