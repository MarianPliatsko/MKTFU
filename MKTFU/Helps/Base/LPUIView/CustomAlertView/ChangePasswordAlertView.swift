//
//  ChahgePasswordAlertView.swift
//  MKTFU
//
//  Created by mac on 2023-03-20.
//

import Foundation
import UIKit

final class ChangePasswordAlertView: LPView {
    
    //MARK: - Properties
    
    var view: UIView!
    var onTryAgainBtnPressed: (() -> Void)?
    var onCancelBtnPressed: (() -> Void)?
    
    //MARK: - IBAction
    
    @IBAction func cancelBtnPressed(_ sender: UIButton) {
        onCancelBtnPressed?()
    }
    
    @IBAction func tryAgainBtnPressed(_ sender: UIButton) {
        onTryAgainBtnPressed?()
    }
    
    //MARK: - Methods
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ChahgePasswordAlertView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
    private func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                 UIView.AutoresizingMask.flexibleHeight]
        addSubview(view)
        self.addConstraints()
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
    
    func addConstraints() {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
