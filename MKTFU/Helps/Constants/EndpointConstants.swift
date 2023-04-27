//
//  EndpointConstants.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

enum EndpointConstants {
    static let searchProduct = "api/Product/search"
    static let productsByCategory = "api/Product/category"
    static let getDeals = "api/Product/deals"
    static let getAllProducts = "api/Product"
    static let changePassword = "api/Auth/changepassword"
    static let notification = "api/User/notifications"
    static let myListing = "api/User/products"
    static let myPurcases = "api/User/purchases"
    static let notificationCount = "api/User/notifications/count"
    static let getUserProfile = "api/User/"
    static let updateUserProfile = "api/User"
    static let updateListing = "api/Product"
    static let confirmSold = "api/Product/complete/"
    static let purchaseListing = "api/Product/checkout/"
    static let createOffer = "api/Product"
    static let cancelSale = "api/Product/cancelsale/"
    static let cancelAndRemove = "api/Product/cancel/"
    static let userRegistration = "api/User/register"
    static let getFAQ = "api/FAQ"
}
