//
//  Condition.swift
//  MKTFU
//
//  Created by mac on 2023-04-13.
//

import Foundation

struct Condition {
    var rawValue: String
    var localizedTitle: String { rawValue }
}

extension Condition {
    static var conditions = [Conditions(rawValue: "New"),
                             Conditions(rawValue: "Used")]
}
