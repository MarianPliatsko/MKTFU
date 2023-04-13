//
//  ImageUICollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-04.
//

import UIKit

class ImageUICollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ImageUICollectionViewCell"
    var onDeletePressed: (() -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet weak var uiImage: UIImageView!
    
    @IBOutlet weak var deleteImgBtn: UIButton! {
        didSet {
            deleteImgBtn.setImage(UIImage(named: "Icon ionic-md-close-circle"), for: .normal)
            deleteImgBtn.layer.cornerRadius = deleteImgBtn.layer.bounds.width / 2
            deleteImgBtn.clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - IBAction
    
    @IBAction func deleteImgBtnPressed(_ sender: UIButton) {
        onDeletePressed?()
    }
    
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
//    func setupUI(productImage: String) {
//        NetworkManager.shared.getImage(from: productImage,
//                                       imageView: uiImage) { result in
//            switch result {
//            case .success(let image):
//                self.uiImage = image
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}

