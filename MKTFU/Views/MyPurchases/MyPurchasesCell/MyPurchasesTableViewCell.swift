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
    
    @IBOutlet private weak var myPurchaseImageView: UIImageView! {
        didSet {
            myPurchaseImageView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 15)
        }
    }
    @IBOutlet private weak var myPurchaseDateLabel: UILabel!
    @IBOutlet private weak var myPurchaseNameLabel: UILabel!
    @IBOutlet private weak var myPurchasePriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(product: Product) {
        myPurchaseImageView.kf.setImage(with: URL(string: product.images[0]))
        myPurchaseDateLabel.text = product.created.formatDate(from: "yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'",
                                                              to: "MMMM dd yyyy")
        myPurchaseNameLabel.text = product.productName
        myPurchasePriceLabel.text = "\(product.price)$"
    }
    
}
