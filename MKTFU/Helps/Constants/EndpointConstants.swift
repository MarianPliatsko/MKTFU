//
//  EndpointConstants.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

enum EndpointConstants {
    static let changePassword = "api/Auth/changepassword"
    static let notification = "api/User/notifications"
    static let myListing = "api/User/products"
    static let myPurcases = "api/User/purchases"
    static let notificationCount = "api/User/notifications/count"
    static let getUserProfile = "api/User/"
    static let updateUserProfile = "api/User"
    static let updateListing = "api/Product"
    static let confirmSold = "api/Product/complete/"
}
