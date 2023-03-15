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
    
    
    
    @IBOutlet weak var stackViewWithImage: UIStackView!
    @IBOutlet weak var emptyStackView: UIStackView!
    
    //    var screenSize: CGRect!
    //    var screenWidth: CGFloat!
    
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
        
        //        screenSize = imageCollectionView.bounds
        //        screenWidth = screenSize.width
        //        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        //               layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        //               layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        //               layout.minimumInteritemSpacing = 0
        //               layout.minimumLineSpacing = 10
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
    
    func layoutConfig() -> UICollectionViewCompositionalLayout {
        let item = CompositionLayout.createItem(width: .fractionalWidth(1),
                                                height: .fractionalHeight(1), spacing: 0)
//        let group = CompositionLayout.createGroup(alignment: .horizontal, width: .fractionalWidth(1), height: .fractionalHeight(1), items: [item])
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        return UICollectionViewCompositionalLayout(section: section)
        
    }
}

//MARK: - extension AddImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource

extension AddImageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if section == 0  {
//            return images.count
//        } else {
//            return 1
//        }
        return section == 0 ? images.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageUICollectionViewCell.identifier, for: indexPath) as? ImageUICollectionViewCell
        
        let addImageCell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.identifier, for: indexPath) as? AddImageCollectionViewCell
        
        if indexPath.section == 0 {
            cell?.uiImage.image = images[indexPath.item]
            cell?.onDeletePressed = { [weak self] in
                self?.images.remove(at: indexPath.item)
            }
            return cell ?? UICollectionViewCell()
        }
        
        else {
            addImageCell?.onNeedUpdate = { [weak self] in
                self?.onNeedUpdate?()
            }
            return addImageCell ?? UICollectionViewCell()
        }
        
        
        return UICollectionViewCell()
//        if indexPath.item == images.count && images.count < 3 {
//            guard let addImageCell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: AddImageCollectionViewCell.identifier, for: indexPath) as? AddImageCollectionViewCell else {return UICollectionViewCell()}
//            addImageCell.onNeedUpdate = { [weak self] in
//                self?.onNeedUpdate?()
//            }
//            return addImageCell
//        } else {
//            guard let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageUICollectionViewCell.identifier, for: indexPath) as? ImageUICollectionViewCell else {return UICollectionViewCell()}
//            cell.uiImage.image = images[indexPath.item]
//            cell.onDeletePressed = { [weak self] in
//                self?.images.remove(at: indexPath.item)
//            }
//            return cell
//        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != images.count {
            mainImageView.image = images[indexPath.item]
        }
    }
}
//MARK: - extension AddImageTableViewCell: UICollectionViewDelegateFlowLayout

//extension AddImageTableViewCell: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.row == 0
//            {
//            return CGSize(width: imageCollectionView.frame.width, height: screenWidth/3)
//            }
//            return CGSize(width: screenWidth/3, height: screenWidth/3)
//    }
//}
