//
//  ProductDetailViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-15.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var product: Product?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productPriceLabel: UILabel!
    @IBOutlet private weak var productDescriptionTextView: UITextView!
    @IBOutlet private weak var usersAccountImageView: UIImageView!
    @IBOutlet private weak var usersNameLabel: UILabel!
    @IBOutlet private weak var productNumberOfListingLabel: UILabel!
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupCollectionView()
        setupUI(data: product!)
    }
    
    //MARK: - IBAction
    
    @IBAction private func iWantThisBtnPressed(_ sender: UIButton) {
        if product != nil {
            coordinator?.goToCheckoutViewController(with: product!)
        }
    }
    
    //MARK: - Methods
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.createLayout(itemWidth: .fractionalWidth(1),
                                                             itemHeight: .fractionalHeight(1),
                                                             groupWidth: .fractionalWidth(1),
                                                             groupHeight: .fractionalHeight(1)), animated: false)
        collectionView.register(ImageCollectionViewCell.nib(), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    private func setupUI(data: Product) {
        productNameLabel.text = data.productName
        productPriceLabel.text = "$\(data.price)"
        productDescriptionTextView.text = data.description
        productNumberOfListingLabel.text = "\(data.sellerListingCount ?? 0)"
        if data.sellerProfile != nil {
            usersNameLabel.text = "\(data.sellerProfile?.firstName ?? "") \(data.sellerProfile?.lastName ?? "")"
        }
    }
}

    //MARK: - extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension ProductDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
        cell.getImage(from: product?.images[indexPath.item] ?? "")
        return cell
    }
}
