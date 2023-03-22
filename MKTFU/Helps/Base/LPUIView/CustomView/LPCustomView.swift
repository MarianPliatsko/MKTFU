//
//  File.swift
//  MKTFU
//
//  Created by mac on 2023-02-07.
//

import Foundation
import UIKit

@IBDesignable
class LPView: UIView {
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            self.layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
            layer.masksToBounds = false
            layer.shadowOffset = CGSize(width: 0,height: 2)
        }
    }
    
    
    @IBInspectable var shadowOpacity: CGFloat = 0.0 {
        
        didSet {
            
            layer.shadowOpacity = Float(shadowOpacity.hashValue)
            layer.masksToBounds = false
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
        
        didSet {
            
            layer.shadowOpacity = Float(shadowRadius.hashValue)
            layer.masksToBounds = false
        }
    }
    
    override internal func awakeFromNib() {
        super.awakeFromNib()
    }
    
}

//MARK: - LpCustomView

final class LpCustomView: LPView, UITextFieldDelegate {
    
    let validate = Validate()
    
    let rightButton = UIButton(type: .custom)
    
    var view: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtInputField: UITextField!
    @IBOutlet weak var lblPasswordSecurityLevel: UILabel!
    
    @IBInspectable var showError: Bool = false {
        didSet {
            lblError.isHidden = !showError
        }
    }
    
    @IBInspectable var showSecurityLevel: Bool = false {
        didSet {
            lblPasswordSecurityLevel.isHidden = !showSecurityLevel
        }
    }
    
    @IBInspectable var title: String = "Title" {
        didSet {
            lblTitle.text = title
        }
    }
    
    @IBInspectable var placeHolder: String = "Placeholder" {
        didSet {
            txtInputField.placeholder = placeHolder
        }
    }
    
    @IBInspectable var errorMessage: String = "Error" {
        didSet {
            lblError.text = errorMessage
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LPCustomView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
    }
    
    //MARK: - Validation methods
    
    //Check email validation after button pressed
    func checkEmail() {
        if let email = txtInputField.text, email != "" {
            if validate.validateEmail.validateEmailId(emailID: email) == false {
                showError = true
            } else {
                showError = false
            }
        }
        reloadInputViews()
    }
    
    private func isValid(with word: String) -> Bool {
        let check = "[A-Za-z]"
        let checkPred = NSPredicate(format:"SELF MATCHES %@", check)
        return checkPred.evaluate(with: word)
    }
    
    
    // Enabling password visibility view on text field
    @IBInspectable var isPasswordVisiblityToggleEnabled: Bool {
        set {
            if newValue {
                addPasswordVisibilityToggle("Icon awesome-eye-slash")
                txtInputField.isSecureTextEntry = true
            }
            else {
                removePasswordVisibilityToggle()
            }
        }
        
        get {
            txtInputField.rightView != nil
        }
    }
    
    private func removePasswordVisibilityToggle() {
        txtInputField.rightView = nil
    }
    
    private func addPasswordVisibilityToggle(_ named: String) {
        
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
        
        txtInputField.rightViewMode = .always
        txtInputField.rightView = rightButton
        
    }
    
    @objc
    private func passwordVisibilityTogglePressed(_ sender: UIButton) {
        sender.isSelected.toggle()
        txtInputField.isSecureTextEntry = sender.isSelected
        if sender.isSelected {
            rightButton.setImage(UIImage(named: "Icon awesome-eye-slash"), for: .selected)
            rightButton.setImage(UIImage(named: "Icon awesome-eye-slash"), for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "Icon awesome-eye"), for: .selected)
            rightButton.setImage(UIImage(named: "Icon awesome-eye"), for: .normal)
        }
    }
}
   
