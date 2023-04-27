//
//  CancelTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-02.
//

import UIKit

class CancelTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CancelTableViewCell"
    var onCancelPressed: (() -> Void)?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var cancelButton: UIButton!{
        didSet {
            cancelButton.tintColor = UIColor.appColor(LPColor.GrayButtonGray)
            cancelButton.titleLabel?.font = UIFont(name: UIFont.appFont(LPFont.OpenSansBold), size: 16)
        }
    }
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - IBAction
    
    @IBAction private func cancelButtonTapped(_ sender: UIButton) {
        onCancelPressed?()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(mode: CreateOfferMode) {
        switch mode {
        case .createProduct:
            cancelButton.setTitle("Cancel", for: .normal)
        case .saveChanges:
            cancelButton.setTitle("Delete listing", for: .normal)
        case .confirmSold:
            cancelButton.setTitle("Cancel listing", for: .normal)
        }
    }
}
