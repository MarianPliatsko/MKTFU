//
//  ImageCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-17.
//

import UIKit
import Kingfisher

class ImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ImageCollectionViewCell"
    
    //MARK: - Outlets
    
    @IBOutlet weak var cellImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func getImage(from urlString: String) {
            let url = URL(string: urlString)
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
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                }
            }
        }
    }
