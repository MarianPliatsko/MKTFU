//
//  DetailListTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-03.
//

import UIKit

class DetailListTableViewCell: UITableViewCell {
    
    static let identifier = "DetailListTableViewCell"

    @IBOutlet weak var lblText: UILabel!
    
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
    
    func setupUI(text: String) {
        lblText.text = text
    }
    
}
