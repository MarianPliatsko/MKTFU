//
//  UITextField+.swift
//  MKTFU
//
//  Created by mac on 2023-01-31.
//

import Foundation
import UIKit

public extension UITextField {
    
    // Enabling password visibility view on text field
    @IBInspectable var isPasswordVisiblityToggleEnabled: Bool {
        set {
            if newValue {
                addPasswordVisibilityToggle()
            }
            else {
                removePasswordVisibilityToggle()
            }
        }
        
        get {
            rightView != nil
        }
    }
    
    private func removePasswordVisibilityToggle() {
        rightView = nil
    }
    
    private func addPasswordVisibilityToggle() {
        let rightButton = UIButton(type: .custom)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightButton.addTarget(
            self,
            action: #selector(passwordVisibilityTogglePressed(_:)),
            for: .touchUpInside
        )
        rightButton.setImage(UIImage(named: "Icon awesome-eye-slash"), for: .selected)
        rightButton.setImage(UIImage(named: "Icon awesome-eye-slash"), for: .normal)
        rightButton.isSelected = true
        
        rightViewMode = .always
        rightView = rightButton
        
    }
    
    @objc
    private func passwordVisibilityTogglePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = sender.isSelected
    }
    
}
