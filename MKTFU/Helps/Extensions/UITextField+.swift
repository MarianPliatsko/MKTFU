//
//  UITextField+.swift
//  MKTFU
//
//  Created by mac on 2023-01-31.
//

import Foundation
import UIKit

extension UITextField {
    
    // Enabling password visibility view on text field
    @IBInspectable var isPasswordVisiblityToggleEnabled: Bool {
        set {
            if newValue {
                addPasswordVisibilityToggle("Icon awesome-eye-slash")
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
    
    private func addPasswordVisibilityToggle(_ named: String) {
        let rightButton = UIButton(type: .custom)
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -16, bottom: 0, right: 0)
        rightButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        rightButton.addTarget(
            self,
            action: #selector(passwordVisibilityTogglePressed(_:)),
            for: .touchUpInside
        )
        rightButton.setImage(UIImage(named: named), for: .selected)
        rightButton.setImage(UIImage(named: named), for: .normal)
        rightButton.isSelected = true
        
        rightViewMode = .always
        rightView = rightButton
        
    }
    
    @objc
    private func passwordVisibilityTogglePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isSecureTextEntry = sender.isSelected
    }
    
    private func isValid(with word: String) -> Bool {
        let check = "[A-Za-z]"
        let checkPred = NSPredicate(format:"SELF MATCHES %@", check)
        return checkPred.evaluate(with: word)
    }
    
}

extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -20, y: 0, width: 10.0, height: 10.0)
        mainView.addSubview(imageView)
        
        if(Direction.Left == direction){ // image left
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
}
