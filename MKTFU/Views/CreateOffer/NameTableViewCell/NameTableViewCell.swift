//
//  NameTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import UIKit

class NameTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "NameTableViewCell"
    private var textInView: ((String) -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var lpUIView: LpCustomView!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lpUIView.txtInputField.addTarget(self,
                                        action: #selector(NameTableViewCell.textFieldDidChange(_:)),
                                         for: .editingChanged)
    }

    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(model: NamePriceAddressCellViewModel) {
        lpUIView.title = model.title
        lpUIView.placeHolder = model.placeholder
        lpUIView.txtInputField.text = "\(model.text)"
        textInView = model.nameTextInView
        if model.isDisabled {
            lpUIView.txtInputField.textColor = UIColor.appColor(LPColor.TextGray40)
            lpUIView.txtInputField.isEnabled = false
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        textInView?(lpUIView.txtInputField.text ?? "")
    }
    
}

