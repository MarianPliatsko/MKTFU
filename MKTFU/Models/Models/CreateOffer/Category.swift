//
//  Category.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct Category {
    var rawValue: String
    var localizedTitle: String { rawValue }
}

extension Category {
    static var categories = [Categories(rawValue: "Vehicles"),
                             Categories(rawValue: "Furniture"),
                             Categories(rawValue: "Electronics"),
                             Categories(rawValue: "Real estate")]
}
