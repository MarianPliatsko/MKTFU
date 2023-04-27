//
//  ProductImagesTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import UIKit
import PhotosUI
import Photos
import Kingfisher

class ProductImagesTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ProductImagesTableViewCell"
    private var images: [String] = []
    private var onNeedUpdate: (() -> Void)?
    private var onDeletePressed: ((String) -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var stackViewWithImage: UIStackView!
    @IBOutlet private weak var emptyStackView: UIStackView!
    @IBOutlet private weak var mainImageView: UIImageView!
    @IBOutlet private weak var imageCollectionView: UICollectionView!
    
    //MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - IBAction
    
    @IBAction private func addImageButtonPressed(_ sender: UIButton) {
        onNeedUpdate?()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    private func setupCollectionView() {
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(ImageUICollectionViewCell.nib(),
                                     forCellWithReuseIdentifier: ImageUICollectionViewCell.identifier)
        imageCollectionView.register(AddImageCollectionViewCell.nib(),
                                     forCellWithReuseIdentifier: AddImageCollectionViewCell.identifier)
        imageCollectionView.collectionViewLayout = layoutConfig()
    }
    
    private func layoutConfig() -> UICollectionViewFlowLayout {
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
    
    func setup(model: ImageCellViewModel) {
        setupCollectionView()
        toggleImagesUI(model: model)
        images = model.images
        onNeedUpdate = model.onAddImageButtonTapped
        onDeletePressed = model.onDeletePressed
    }
    
    private func toggleImagesUI(model: ImageCellViewModel) {
        let noImages = model.images.isEmpty
        if noImages {
            showEmptyImagesUI()
        }
        else {
            hideEmptyImagesUI()
            imageCollectionView.reloadData()
        }
    }

    private func showEmptyImagesUI() {
        stackViewWithImage.isHidden = true
        emptyStackView.isHidden = false
    }
    
    private func hideEmptyImagesUI() {
        stackViewWithImage.isHidden = false
        emptyStackView.isHidden = true
    }
}

//MARK: - extension ProductImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource

extension ProductImagesTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? images.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell = imageCollectionView.dequeueReusableCell(
                withReuseIdentifier: ImageUICollectionViewCell.identifier,
                for: indexPath) as? ImageUICollectionViewCell else {return UICollectionViewCell()}
            mainImageView.kf.setImage(with: URL(string: images[0]))
            cell.setup(imageURL: images[indexPath.item])
            cell.onDeletePressed = { [weak self] in
                self?.onDeletePressed?(self?.images[indexPath.item] ?? "")
            }
            return cell
        default:
            guard let addImageCell = imageCollectionView.dequeueReusableCell(
                withReuseIdentifier: AddImageCollectionViewCell.identifier,
                for: indexPath) as? AddImageCollectionViewCell else {return UICollectionViewCell()}
            if images.count < 3 {
                addImageCell.onNeedUpdate = { [weak self] in
                    self?.onNeedUpdate?()
                }
                return addImageCell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item != images.count {
            mainImageView.kf.setImage(with: URL(string: images[indexPath.item]))
        }
    }
}
