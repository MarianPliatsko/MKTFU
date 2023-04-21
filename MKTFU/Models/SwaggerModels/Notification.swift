//
//  Notification.swift
//  MKTFU
//
//  Created by mac on 2023-04-14.
//

import Foundation

struct Notification: Codable {
    let id: String
    let message: String
    let created: String
    let read: Bool
}
