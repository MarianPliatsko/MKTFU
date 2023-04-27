//
//  HomeCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-10.
//

import UIKit
import Kingfisher

class HomeCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "HomeCollectionViewCell"
    
    //MARK: - Outlet
    
    @IBOutlet private weak var cellImageView: UIImageView!
    @IBOutlet private weak var lblDescription: UILabel!
    @IBOutlet private weak var lblPrice: UILabel!
    
    //MARK: - Nib Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellConfiguratin()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(text: String, price: Double) {
        lblDescription.text = text
        lblPrice.text = "$\(price)"
    }
    
    func getImage(from url: [String]) {
        cellImageView.image = nil
        if url.last != nil {
            let url = URL(string: url.last!)
            let processor = DownsamplingImageProcessor(size: cellImageView.bounds.size)
            cellImageView.kf.indicatorType = .activity
            cellImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    .cacheOriginalImage
                ])
            {
                result in
                switch result {
                case .success(_):
                    break
                case .failure(_):
                    break
                }
            }
        }
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
