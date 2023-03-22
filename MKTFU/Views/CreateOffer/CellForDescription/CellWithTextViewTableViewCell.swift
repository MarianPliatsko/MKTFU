//
//  CellWithTextViewTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-01.
//

import UIKit

class CellWithTextViewTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CellWithTextViewTableViewCell"
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var textView: LPTextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(title: String) {
        lblTitle.text = title
    }
}
