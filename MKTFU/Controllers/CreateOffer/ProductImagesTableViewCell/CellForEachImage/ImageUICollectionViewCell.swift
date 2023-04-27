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
    
    @IBOutlet private weak var uiImage: UIImageView!
    
    @IBOutlet private weak var deleteImgBtn: UIButton! {
        didSet {
            deleteImgBtn.setImage(UIImage(named: "Icon ionic-md-close-circle"), for: .normal)
            deleteImgBtn.layer.cornerRadius = deleteImgBtn.layer.bounds.width / 2
            deleteImgBtn.clipsToBounds = true
        }
    }
    
    //MARK: - IBAction
    
    @IBAction private func deleteImgBtnPressed(_ sender: UIButton) {
        onDeletePressed?()
    }
    
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
}

