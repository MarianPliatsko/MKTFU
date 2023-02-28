//
//  ImageCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-17.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ImageCollectionViewCell"
    
    //MARK: - Outlets
    
    @IBOutlet weak var cellImageView: UIImageView!

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
    func setup(image: UIImage) {
        cellImageView.image = image
    }

}
