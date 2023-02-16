//
//  HomeViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-10.
//

import UIKit

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    private let images: [UIImage] = Array(1...11).map { UIImage(named: String($0))!}
    private let text = ["Cat&Dog",
                        "Cat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&Do",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog&DogCat&Dog"]
    
    //MARK: - Outlets
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        
        //register Home Header Collection View Cell
        headerCollectionView.register(HomeHeaderCollectionViewCell.nib(),forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.identifier)
        
        //register Home Collection View Cell
        collectionView.register(HomeCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        collectionView.collectionViewLayout = layoutConfig()
    }
    
    // MARK: - Methods
    
    // create composition layout
    //    private func createLayout() -> UICollectionViewCompositionalLayout {
    //
    //        // Items
    //        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2),
    //                                              heightDimension: .fractionalHeight(1))
    //
    //        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    //        item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
    //
    //        // Group
    //        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
    //                                               heightDimension: .fractionalHeight(1/2))
    //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
    //                                                       subitems: [item])
    //
    //        // Section
    //        let section = NSCollectionLayoutSection(group: group)
    //
    //        return UICollectionViewCompositionalLayout(section: section)
    //
    //    }
    /*
    let layout = UICollectionViewCompositionalLayout(sectionProvider: {
        (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .estimated(30))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(30))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, repeatingSubitem: item, count: 1)
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 16
        
        return section
    })
     */
   
    func layoutConfig() -> UICollectionViewCompositionalLayout {
        
        let item = CompositionLayout.createItem(width: .fractionalWidth(1),
                                                height: .estimated(50), spacing: 10)
        
        let itemGroup = CompositionLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .estimated(50), item: item, count: 1)
        
        itemGroup.interItemSpacing = .flexible(8)
        
        let item2 = CompositionLayout.createItem(width: .fractionalWidth(0.5),
                                                 height: .estimated(30), spacing: 10)
        
        let item2Group = CompositionLayout.createGroup(alignment: .vertical, width: .fractionalWidth(0.5), height: .estimated(30), item: item, count: 1)
        
         itemGroup.interItemSpacing = .flexible(8)
        
        let mainGroup =  CompositionLayout.createGroup(alignment: .horizontal,
                                                       width: .fractionalWidth(1),
                                                       height: .estimated(30), items: [itemGroup, item2Group])
        
        let section = NSCollectionLayoutSection(group: mainGroup)
        
        section.interGroupSpacing = 8
        //            section.orthogonalScrollingBehavior = .groupPagingCentered
        return UICollectionViewCompositionalLayout(section: section)
    }
     
}
// MARK: - extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return images.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(image: images[indexPath.row], text: text[indexPath.row])
            cell.backgroundColor = .lightGray
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCollectionViewCell.identifier, for: indexPath) as? HomeHeaderCollectionViewCell else {return UICollectionViewCell()}
            cell.setupHeader(image: images[indexPath.row], text: "Some text")
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell: HomeHeaderCollectionViewCell = Bundle.main.loadNibNamed(
            HomeHeaderCollectionViewCell.identifier,
            owner: self,
            options: nil)?.first as? HomeHeaderCollectionViewCell else { return CGSize.zero}
        
        cell.setupHeader(image: images[indexPath.row], text: "Some text")
        cell.setNeedsLayout()
        cell.layoutIfNeeded()
        let size: CGSize = cell.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        return CGSize(width: size.width, height: collectionView.frame.size.height)
    }
}
