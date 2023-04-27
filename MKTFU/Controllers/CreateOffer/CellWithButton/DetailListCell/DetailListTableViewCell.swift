//
//  DetailListTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-03.
//

import UIKit

class DetailListTableViewCell: UITableViewCell {
    
    static let identifier = "DetailListTableViewCell"

    @IBOutlet private weak var lblText: UILabel!

    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(data: PickerItem) {
        lblText.text = data.localizedTitle
    }
    
}
