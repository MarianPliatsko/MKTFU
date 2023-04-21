//
//  ConfirmTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-02.
//

import UIKit

class ConfirmTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ConfirmTableViewCell"
    var onConfirmPressed: (() -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var confirmButton: UIButton! {
        didSet {
            confirmButton.tintColor = UIColor.appColor(LPColor.VoidWhite)
            confirmButton.titleLabel?.font = UIFont(name: UIFont.appFont(LPFont.OpenSansBold), size: 16)
        }
    }
    
    //MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - IBAction
    
    @IBAction private func confirmButtonPressed(_ sender: UIButton) {
        onConfirmPressed?()
    }
    
    //MARK: - Methods
      // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(mode: Mode) {
        switch mode {
        case .createProduct:
            confirmButton.setTitle("Create product", for: .normal)
        case .saveChanges:
            confirmButton.setTitle("Save changes", for: .normal)
        case .confirmSold:
            confirmButton.setTitle("Confirm sold", for: .normal)
        }
        
    }
    
}
