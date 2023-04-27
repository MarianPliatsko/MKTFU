//
//  FAQTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-04-11.
//

import UIKit

class FAQTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "FAQTableViewCell"
    
    //MARK: - Outlet
    
    @IBOutlet private weak var faqQuestionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    //MARK: - Methods
    
    static func nib() -> UINib {
       let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(faq: FAQ) {
        faqQuestionLabel.text = faq.question
    }
    
}
