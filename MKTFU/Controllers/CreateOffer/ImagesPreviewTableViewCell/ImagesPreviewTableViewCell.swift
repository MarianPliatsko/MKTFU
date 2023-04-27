//
//  ImagesPreviewTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-04-23.
//

import UIKit

class ImagesPreviewTableViewCell: UITableViewCell {
    
    static let identifier = "ImagesPreviewTableViewCell"
    private var images: [String] = []
    
    @IBOutlet private weak var imagesPreviewCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }

    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(model: [String]) {
        images = model
    }
    
    private func setupCollectionView() {
        imagesPreviewCollectionView.dataSource = self
        imagesPreviewCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.createLayout(itemWidth: .fractionalWidth(1),
                                                             itemHeight: .fractionalHeight(1),
                                                             groupWidth: .fractionalWidth(1),
                                                             groupHeight: .fractionalHeight(1)), animated: false)
        imagesPreviewCollectionView.register(ImagesPreviewCollectionViewCell.nib(),
                                             forCellWithReuseIdentifier: ImagesPreviewCollectionViewCell.identifier)
    }
}

extension ImagesPreviewTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = imagesPreviewCollectionView.dequeueReusableCell(withReuseIdentifier: ImagesPreviewCollectionViewCell.identifier, for: indexPath) as? ImagesPreviewCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(image: images[indexPath.item])
        return cell
    }
}
