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
    
    //MARK: - Outlets
    
    

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
}
