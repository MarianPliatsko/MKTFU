//
//  City.swift
//  MKTFU
//
//  Created by mac on 2023-03-15.
//

import Foundation

struct City: PickerItem {
    var rawValue: String
    var localizedTitle: String { rawValue }
}

extension City {
    static var cities = [City(rawValue: "Calgary"), City(rawValue: "Brook")]
}
