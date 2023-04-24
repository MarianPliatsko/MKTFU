//
//  ImagesPreviewCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-04-23.
//

import UIKit
import Kingfisher

class ImagesPreviewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImagesPreviewCollectionViewCell"

    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(image: String) {
        setupUI(image: image)
    }
    
    private func setupUI(image: String) {
        imageView.kf.setImage(with: URL(string: image))
    }
}
