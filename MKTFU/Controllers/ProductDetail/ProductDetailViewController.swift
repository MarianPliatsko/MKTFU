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
    
    private let images: [UIImage] = Array(1...10).map { UIImage(named: String($0))!}
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productDescriptionTextView: UITextView!
    @IBOutlet weak var usersAccountImageView: UIImageView!
    @IBOutlet weak var usersNameLabel: UILabel!
    @IBOutlet weak var productNumberOfListingLabel: UILabel!
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //setup layout for collectionView
        collectionView.collectionViewLayout = createLayout()
        
        // register nib
        collectionView.register(ImageCollectionViewCell.nib(), forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        
        setupUI(data: product!)
    }
    
    //MARK: - IBAction
    
    @IBAction func iWantThisBtnPressed(_ sender: UIButton) {
        if product != nil {
            coordinator?.goToCheckoutViewController(with: product!)
        }
    }
    
    
    //MARK: - Methods
    
    //create layout for collectionView
    func createLayout() -> UICollectionViewCompositionalLayout {
        
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
    
    func setupUI(data: Product) {
        productNameLabel.text = data.productName
        productPriceLabel.text = "$\(data.price)"
        productDescriptionTextView.text = data.description
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
