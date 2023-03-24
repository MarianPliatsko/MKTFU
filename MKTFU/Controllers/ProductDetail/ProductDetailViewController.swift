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
    var dataSource = ItemsDataTest()
    private let images: [UIImage] = Array(1...10).map { UIImage(named: String($0))!}
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemPriceLabel: UILabel!
    @IBOutlet weak var itemDetailTextView: UITextView!
    @IBOutlet weak var itemConditionStatusLabel: UILabel!
    @IBOutlet weak var itemSellerImageView: UIImageView!
    @IBOutlet weak var itemSellerName: UILabel!
    @IBOutlet weak var itemListingNumberLabel: UILabel!
    
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
        
        setupUI(data: dataSource)
        
    }
    
    //MARK: - IBAction
    
    @IBAction func iWantThisBtnPressed(_ sender: UIButton) {
        coordinator?.goToCheckoutViewController(dataSource: dataSource)
    }
    
    //MARK: - Methods
    
    func setupUI(data: ItemsDataTest) {
        itemNameLabel.text = data.name
        itemPriceLabel.text = "$\(data.price)"
        itemDetailTextView.text = data.detail
        itemConditionStatusLabel.text = data.status.name
    }
    
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
}

    //MARK: - extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension ProductDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
        cell.setup(image: images[indexPath.row])
        
        return cell
    }
}
