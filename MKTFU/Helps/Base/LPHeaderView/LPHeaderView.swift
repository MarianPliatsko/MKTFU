//
//  LPHeaderView.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import UIKit

@IBDesignable
class LPHeaderView: LPView {
    
    var view: UIView!
    var onBackPressed: (() -> Void)?
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBAction func backButtonPressed(_ sender: Any) {
        onBackPressed?()
    }

    @IBInspectable var title: String = "Title" {
        didSet {
            lblTitle.text = title
        }
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LPHeaderView", bundle: bundle)
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
