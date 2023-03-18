//
//  MyListingTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-16.
//

import UIKit

class MyListingTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "MyListingTableViewCell"
    
    //MARK: - Outlet
    
    @IBOutlet weak var myListingImageView: UIImageView!{
        didSet {
            myListingImageView.round(corners: [.topLeft, .bottomLeft], cornerRadius: 15)
        }
    }
    @IBOutlet weak var myListingDateLabel: UILabel!
    @IBOutlet weak var myListingItemTitleLabel: UILabel!
    @IBOutlet weak var myListingItemPriceLabel: UILabel!
    @IBOutlet weak var myListUsedConditionView: UIView!
    
    //MARK: - Life cycle

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
    
    func setup(item: MyList) {
        myListingImageView.image = item.image
        myListingDateLabel.text = item.date.description
        myListingItemTitleLabel.text = item.title
        myListingItemPriceLabel.text = "$\(item.price)"
        myListUsedConditionView.isHidden = item.usedCondition
    }
}
