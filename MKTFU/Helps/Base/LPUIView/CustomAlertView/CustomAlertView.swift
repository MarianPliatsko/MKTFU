//
//  ChahgePasswordAlertView.swift
//  MKTFU
//
//  Created by mac on 2023-03-20.
//

import Foundation
import UIKit

final class CustomAlertView: LPView {
    
    //MARK: - Properties
    
    private var view: UIView!
    private var onTryAgainBtnPressed: (() -> Void)?
    private var onCancelBtnPressed: (() -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var alertTextLabel: UILabel!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    //MARK: - IBAction
    
    @IBAction private func cancelBtnPressed(_ sender: UIButton) {
        onCancelBtnPressed?()
    }
    
    @IBAction private func tryAgainBtnPressed(_ sender: UIButton) {
        onTryAgainBtnPressed?()
    }
    
    //MARK: - Methods
    
    func showAlert(view: UIView,
                   alertText: String,
                   leftButtonText: String,
                   rightButtonText: String,
                   onRightButton: @escaping () -> Void,
                   onLeftButton: @escaping () -> Void) {
        view.addSubview(self.view)
        alertTextLabel.text = alertText
        leftButton.setTitle(leftButtonText, for: .normal)
        rightButton.setTitle(rightButtonText, for: .normal)
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        self.view.backgroundColor = UIColor.appColor(LPColor.TextGray40)
        self.onTryAgainBtnPressed = onRightButton
        self.onCancelBtnPressed = onLeftButton
    }
    
    func hideAlert() {
        self.view.removeFromSuperview()
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomAlertView", bundle: bundle)
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
