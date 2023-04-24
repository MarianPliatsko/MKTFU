//
//  ProductDescriptionTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-01.
//

import UIKit

class ProductDescriptionTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ProductDescriptionTableViewCell"
    var textInView: ((String) -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: LPTextView!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.delegate = self
    }

    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(model: DescriptionCellViewModel) {
        lblTitle.text = model.title
        textView.text = model.text
        textInView = model.descriptionTextInView
        if model.isDisabled {
            textView.textColor = UIColor.appColor(LPColor.TextGray40)
            textView.isEditable = false
        }
    }
}

extension ProductDescriptionTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        textInView?(textView.text)
    }
}
