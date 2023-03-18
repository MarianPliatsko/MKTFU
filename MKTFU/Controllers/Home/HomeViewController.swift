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
    private var filteredCityNameList: [String] = []
    let homeDataSource = Home(city: City(),
                              productCategory: [ProductCategory(name: "Deals",
                                                                image: UIImage(named: "Path 2") ?? UIImage()),
                                               ProductCategory(name: "Cars and vehicles",
                                                               image: UIImage(named: "Path 4") ?? UIImage()),
                                               ProductCategory(name: "Furniture",
                                                               image: UIImage(named: "Path 7") ?? UIImage()),
                                               ProductCategory(name: "Electronics",
                                                               image: UIImage(named: "Path 9") ?? UIImage()),
                                               ProductCategory(name: "Real estate",
                                                               image: UIImage(named: "Path 5") ?? UIImage())],
                              advertisementItems: [Items(image: UIImage(named: "1") ?? UIImage(),
                                                         name: "Iteme 1",
                                                         price: "100")])
    
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
        filteredCityNameList = homeDataSource.city.cityList
        
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
            return homeDataSource.advertisementItems.count
        } else {
            return homeDataSource.productCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(image: homeDataSource.advertisementItems[indexPath.item].image,
                       text: homeDataSource.advertisementItems[indexPath.item].name,
                       price: homeDataSource.advertisementItems[indexPath.item].price)
            cell.backgroundColor = .lightGray
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCollectionViewCell.identifier, for: indexPath) as? HomeHeaderCollectionViewCell else {return UICollectionViewCell()}
            cell.setupHeader(image: homeDataSource.productCategory[indexPath.item].image,
                             text: homeDataSource.productCategory[indexPath.item].name)
            return cell
        }
    }
}

//MARK: - extension HomeViewController: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        let imgHeight = calculateImageHeight(sourceImage: homeDataSource.advertisementItems[indexPath.item].image , scaledToWidth: cellWidth)
        let textHeight = requiredHeight(text: homeDataSource.advertisementItems[indexPath.item].name, cellWidth: cellWidth)
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
        cityButton.setTitle(homeDataSource.city.cityList[indexPath.row], for: .normal)
        cityNameLabel.text = homeDataSource.city.cityList[indexPath.row]
    }
}

//MARK: - extension HomeViewController: UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCityNameList = []
        if searchText == "" {
            filteredCityNameList = homeDataSource.city.cityList
        }
        for word in homeDataSource.city.cityList {
            if word.contains(searchText) {
                filteredCityNameList.append(word)
            }
        }
        self.cityListTableView.reloadData()
    }
}
