//
//  MyPurchasesTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit

class MyPurchasesTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "MyPurchasesTableViewCell"
    
    //MARK: - Outlet
    
    @IBOutlet weak var myListingImageView: UIImageView! {
        didSet {
            myListingImageView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 15)
        }
    }
    
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
