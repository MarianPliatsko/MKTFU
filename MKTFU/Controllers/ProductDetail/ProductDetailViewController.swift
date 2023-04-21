//
//  ProductDetailViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-15.
//

import UIKit

class ProductDetailViewController: UIViewController, Storyboarded {
    
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
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        setupCollectionView()
        setupUI(data: product!)
    }
    
    //MARK: - IBAction
    
    @IBAction func iWantThisBtnPressed(_ sender: UIButton) {
        if product != nil {
            coordinator?.goToCheckoutViewController(with: product!)
        }
    }
    
    
    //MARK: - Methods
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(ImageCollectionViewCell.nib(), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        
        let item = CompositionLayout.createItem(width: .fractionalWidth(1),
                                                height: .fractionalHeight(1),
                                                spacing: 0)
        
        let group = CompositionLayout.createGroup(alignment: .horizontal,
                                                  width: .fractionalWidth(1),
                                                  height: .fractionalHeight(1),
                                                  item: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
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

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        product?.images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
        cell.getImage(from: product?.images[indexPath.item] ?? "")
        return cell
    }
}
