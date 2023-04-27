//
//  HomeHeaderCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-13.
//

import UIKit

class HomeHeaderCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "HomeHeaderCollectionViewCell"
    
    @IBOutlet private weak var headerImageView: UIImageView!
    @IBOutlet private weak var lblHeader: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setupUI()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupHeader(image: UIImage, text: String) {
        headerImageView.image = image
        lblHeader.text = text
    }
    
    private func setupUI() {
        let cellColor = UIView(frame: bounds)
        cellColor.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
        self.selectedBackgroundView = cellColor
    }

}
