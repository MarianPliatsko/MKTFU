//
//  Notifications.swift
//  MKTFU
//
//  Created by mac on 2023-04-19.
//

import Foundation

struct Notifications: Codable {
    let new: [Notification]
    let seen: [Notification]
}
