//
//  CustomViewWithButton.swift
//  MKTFU
//
//  Created by mac on 2023-03-01.
//

import Foundation
import UIKit

final class LpCustomViewWithButton: LPView, UITextFieldDelegate {
    
    
    let rightButton = UIButton(type: .custom)
    
    var view: UIView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtInputField: UITextField!
    
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
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LpCustomViewWithButton", bundle: bundle)
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
        addButtonInTextField("Path 124")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        xibSetup()
        addButtonInTextField("Path 124")
    }
    
    private func addButtonInTextField(_ named: String) {
        
        rightButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        rightButton.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
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
       print(sender)
    }
}
   
