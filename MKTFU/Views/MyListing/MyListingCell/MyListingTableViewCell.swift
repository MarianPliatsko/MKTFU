//
//  MyListingTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-16.
//

import UIKit
import Kingfisher

class MyListingTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "MyListingTableViewCell"
    var images: ((UIImage) -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet weak var myListingImageView: UIImageView!{
        didSet {
            myListingImageView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 15)
        }
    }
    @IBOutlet weak var myListingDateLabel: UILabel!
    @IBOutlet weak var myListingItemTitleLabel: UILabel!
    @IBOutlet weak var myListingItemPriceLabel: UILabel!
    @IBOutlet weak var myListUsedConditionView: UILabel!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(product: Product) {
        myListingDateLabel.text = product.created.formatDate(from: "yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'",
                                                             to: "MMMM dd yyyy")
        myListingItemTitleLabel.text = product.productName
        myListingItemPriceLabel.text = "$\(product.price)"
        myListUsedConditionView.text = product.condition?.localizedTitle
        if !product.images.isEmpty {
            myListingImageView.kf.setImage(with: URL(string: product.images[0]))
        }
    }
}
