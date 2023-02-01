//
//  UIColor+.swift
//  MKTFU
//
//  Created by mac on 2023-01-30.
//

import Foundation
import UIKit

enum LPColor: String {
    case LighestPurple
    case MediumestPurple
    case DarkestPurple
    case OccasionalPurple
    case GoodJobGreen
    case WarningYellow
    case DisabledGray
}

extension UIColor {
    static func appColor(_ name: LPColor) -> UIColor! {
        return UIColor(named: name.rawValue)
    }
}
