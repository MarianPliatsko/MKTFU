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

class LpCustomView: LPView, UITextFieldDelegate {
    
    let validate = Validate()
    
    var view: UIView!
    
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblError: UILabel!
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
}
