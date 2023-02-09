//
//  UIButton+.swift
//  MKTFU
//
//  Created by mac on 2023-02-07.
//

import Foundation
import UIKit

extension UIButton {
    func setupYellowButtonUI(text: String) {
        let attributedTitle = NSAttributedString(
            string: text ,
            attributes: [
                .foregroundColor: UIColor.appColor(LPColor.WarningYellow)!,
                .font: UIFont(name: "OpenSans-Bold",
                              size: 14)!,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        self.setAttributedTitle(attributedTitle, for: .normal)
    }
}

