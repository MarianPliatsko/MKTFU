//
//  AddImageTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import UIKit
import PhotosUI
import Photos

class AddImageTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "AddImageTableViewCell"
    var images: [UIImage] = [] {
        didSet {
            imageCollectionView.reloadData()
            print(images.count)
        }
    }
    var onNeedUpdate: (() -> Void)?
    var dataSourceUpdate: (([UIImage]) -> Void)?
    var onDeletePressed: (() -> Void)?
    
    
    
    @IBOutlet weak var stackViewWithImage: UIStackView!
    @IBOutlet weak var emptyStackView: UIStackView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        imageCollectionView.register(ImageUICollectionViewCell.nib(),
                                     forCellWithReuseIdentifier: ImageUICollectionViewCell.identifier)
        imageCollectionView.register(AddImageCollectionViewCell.nib(),
                                     forCellWithReuseIdentifier: AddImageCollectionViewCell.identifier)
        
        imageCollectionView.collectionViewLayout = layoutConfig()
    }
    
    //MARK: - IBAction
    
    @IBAction func addImageButtonPressed(_ sender: UIButton) {
        onNeedUpdate?()
    }
    
    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    // flow layout configuration
    func layoutConfig() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        layout.scrollDirection = .horizontal
        let width = UIScreen.main.bounds.width / 3
        let height = imageCollectionView.frame.size.height
        
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        
        return layout
    }
}

//MARK: - extension AddImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource

extension AddImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? images.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageUICollectionViewCell.identifier, for: indexPath) as? ImageUICollectionViewCell
        
        let addImageCell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.identifier, for: indexPath) as? AddImageCollectionViewCell
        
        if indexPath.section == 0 {
            mainImageView.image = images[0]
            cell?.uiImage.image = images[indexPath.item]
            cell?.onDeletePressed = { [weak self] in
                self?.images.remove(at: indexPath.item)
                self?.dataSourceUpdate?(self?.images ?? [UIImage]())
                self?.onDeletePressed?()
            }
            return cell ?? UICollectionViewCell()
        } else {
            if images.count < 3 {
                addImageCell?.onNeedUpdate = { [weak self] in
                    self?.onNeedUpdate?()
                }
                return addImageCell ?? UICollectionViewCell()
            } else {
                print("3 images is maximum for this screen")
            }
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != images.count {
            mainImageView.image = images[indexPath.item]
        }
    }
}
