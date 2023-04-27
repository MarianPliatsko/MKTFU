//
//  RegExConstants.swift
//  MKTFU
//
//  Created by mac on 2023-04-24.
//

import Foundation

struct ValidationConstants {
    static let name = "^\\w{3,18}$"
    static let email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let password = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[A-Z]).{6,}$"
}
