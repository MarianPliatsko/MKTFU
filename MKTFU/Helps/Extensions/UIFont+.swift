//
//  UIFonts+.swift
//  MKTFU
//
//  Created by mac on 2023-02-07.
//

import Foundation
import UIKit

enum LPFont: String {
    case OpenSansRegular
    case OpenSansSemibold
    case OpenSansBold
    case OpenSansLight
}
extension UIFont {
    static func appFont(_ name: LPFont) -> String {
        return name.rawValue
    }
}
