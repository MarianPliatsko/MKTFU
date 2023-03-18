//
//  HomeCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-10.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeCollectionViewCell"
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellConfiguratin()
    }
    
    // Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    // setup cell
    func setup(image: UIImage, text: String, price: String) {
        cellImageView.image = image
        lblDescription.text = text
        lblPrice.text = "$\(price)"
    }
    
    private func cellConfiguratin() {
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.shadowRadius = 8.0
        layer.shadowOpacity = 0.10
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}
