//
//  LPTextView.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import Foundation
import UIKit

@IBDesignable
class LPTextView: UITextView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = false
        }
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
}
