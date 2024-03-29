//
//  AddImageCollectionViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-05.
//

import UIKit
import PhotosUI
import Photos

class AddImageCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "AddImageCollectionViewCell"
    var onNeedUpdate: (() -> Void)?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var addImageView: LPView!
    
    //MARK: - IBAction
    
    @IBAction private func addImageButtonPressed(_ sender: UIButton) {
        onNeedUpdate?()
    }
    
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
}




