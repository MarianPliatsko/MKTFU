//
//  NotificationSectionHeaderView.swift
//  MKTFU
//
//  Created by mac on 2023-03-21.
//

import Foundation
import UIKit

final class NotificationSectionHeaderView: UIView {
    
    private var view: UIView!
    
    @IBOutlet private weak var sectionTextLabel: UILabel!
    
    func setup(isNew: Bool) {
        switch isNew {
        case true:
            sectionTextLabel.text = "New for you"
        case false:
            sectionTextLabel.text = "Previously seen"
        }
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "NotificationSectionHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        view.backgroundColor = .clear
        addSubview(view)
    }
    private override init(frame: CGRect) {
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
