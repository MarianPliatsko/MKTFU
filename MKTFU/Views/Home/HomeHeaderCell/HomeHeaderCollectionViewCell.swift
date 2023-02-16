//
//  HomeHeaderCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-13.
//

import UIKit

class HomeHeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeHeaderCollectionViewCell"
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var lblHeader: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    // setup cell
    func setupHeader(image: UIImage, text: String) {
        headerImageView.image = image
        lblHeader.text = text
    }

}
