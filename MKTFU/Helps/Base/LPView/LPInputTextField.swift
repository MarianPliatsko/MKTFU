//
//  LBView.swift
//  MKTFU
//
//  Created by Duy Pham on 2023-01-30.
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

class LPInputTextField: LPView {
    var view:UIView!
    @IBOutlet weak private var lblTitle: UILabel!
    @IBOutlet weak private var lblError: UILabel!
    @IBOutlet weak var txtInputField: UITextField!
    @IBInspectable var title: String = "Title" {
        didSet {
            lblTitle.text = title
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LPInputTextField", bundle: bundle)
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
}
