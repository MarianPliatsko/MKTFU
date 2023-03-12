//
//  ConfirmTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-02.
//

import UIKit

class ConfirmTableViewCell: UITableViewCell {
    var onConfirmPressed: (() -> Void)?
    
    //MARK: - Properties
    
    static let identifier = "ConfirmTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - IBAction
    
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        onConfirmPressed?()
    }
    

    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
}
