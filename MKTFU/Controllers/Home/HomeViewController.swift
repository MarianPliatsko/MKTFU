//
//  HomeViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-10.
//

import UIKit

class HomeViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    private let images: [UIImage] = Array(1...10).map { UIImage(named: String($0))!}
    private let text = ["Cat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&Do",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog",
                        "Cat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&DogCat&Dog&DogCat&Dog"]
    private let cityNameList = ["Calgary", "Edmonton", "Lviv"]
    private var filteredCityNameList: [String] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var headerCollectionView: UICollectionView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cityButton: UIButton!
    
    @IBOutlet weak var citySearchView: UIView!
    @IBOutlet weak var citySearchBar: UISearchBar!
    @IBOutlet weak var cityListTableView: UITableView!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    @IBOutlet weak var createListingView: UIControl! {
        didSet {
            createListingView.layer.cornerRadius = 25
            createListingView.clipsToBounds = true
        }
    }
    
    //MARK: - IBAction
    
    
    @IBAction func createListingViewPressed(_ sender: Any) {
        coordinator?.goToCreateOfferVC()
    }
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteredCityNameList = cityNameList
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        
        citySearchView.isHidden = true
        cityViewUISetup()
        
        //register Home Table View Cell
        cityListTableView.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        //register Home Header Collection View Cell
        headerCollectionView.register(HomeHeaderCollectionViewCell.nib(),forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.identifier)
        
        //register Home Collection View Cell
        collectionView.register(HomeCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        // layout for collection view
        let layout = PinterestLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        // layout for header collection view
        headerCollectionView.collectionViewLayout = headerLayoutConfig()
    }
    
    //MARK: - IBActions
    
    @IBAction func cityButtonPressed(_ sender: UIButton) {
        citySearchView.isHidden = !citySearchView.isHidden
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        coordinator?.goToMenuViewController()
    }
    
    // MARK: - Methods
    
    //create composition layout
    func headerLayoutConfig() -> UICollectionViewCompositionalLayout {
        let item = CompositionLayout.createItem(width: .absolute(120),
                                                height: .fractionalHeight(1), spacing: 0)
        let group = CompositionLayout.createGroup(alignment: .horizontal, width: .absolute(100), height: .fractionalHeight(1), item: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func cityViewUISetup() {
        citySearchView.layer.cornerRadius = 20
        citySearchView.clipsToBounds = true
    }
}
//MARK: - extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        coordinator?.goToProductDetailVC()
    }
    
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

//MARK: - extension HomeViewController: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let imgHeight = calculateImageHeight(sourceImage: images[indexPath.row] , scaledToWidth: cellWidth)
        let textHeight = requiredHeight(text: text[indexPath.row], cellWidth: cellWidth)
        return (imgHeight + textHeight + 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.headerCollectionView {
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        } else {
            return CGSize(width: 100, height: 100)
        }
    }
}

//MARK: - extension HomeViewController: PinterestLayoutDelegate

extension HomeViewController: PinterestLayoutDelegate {
    
    func calculateImageHeight (sourceImage: UIImage, scaledToWidth: CGFloat) -> CGFloat {
        let oldWidth = CGFloat(sourceImage.size.width)
        let scaleFactor = scaledToWidth / oldWidth
        let newHeight = CGFloat(sourceImage.size.height) * scaleFactor
        return newHeight
    }
    
    func requiredHeight(text:String , cellWidth : CGFloat) -> CGFloat {
        let font = UIFont(name: UIFont.appFont(.OpenSansRegular), size: 14.0)
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: cellWidth, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
}

//MARK: - extension HomeViewController: UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCityNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
        cell.cityNameLabel.text = filteredCityNameList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityButton.setTitle(cityNameList[indexPath.row], for: .normal)
        cityNameLabel.text = cityNameList[indexPath.row]
    }
}

//MARK: - extension HomeViewController: UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCityNameList = []
        if searchText == "" {
            filteredCityNameList = cityNameList
        }
        for word in cityNameList {
            if word.contains(searchText) {
                filteredCityNameList.append(word)
            }
        }
        self.cityListTableView.reloadData()
    }
}
