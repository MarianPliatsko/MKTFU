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
    private var cities: [String] = []
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
    
    var dataSource = ItemsTest()
    var citiesDataSorce = CityListTest()
    
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
        
        fetchItems()
        fetchCityList()
        
        self.cityButton.setTitle("", for: .normal)
        self.cityNameLabel.text = ""
        
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
    
    // fetch the data
    func fetchItems() {
        NetworkManager.shared.request(url: URL(string: "https://duyphamsg.000webhostapp.com/index.php/item/list"),
                                      type: ItemsTest.self,
                                      token: nil,
                                      httpMethod: .get,
                                      parameters: nil) { result in
            switch result {
            case .success(let success):
                self.dataSource = success
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchCityList() {
        NetworkManager.shared.request(url: URL(string: "https://duyphamsg.000webhostapp.com/index.php/city/list"),
                                      type: CityListTest.self,
                                      token: nil,
                                      httpMethod: .get,
                                      parameters: nil) { result in
            switch result {
            case .success(let success):
                self.citiesDataSorce = success
                for city in self.citiesDataSorce.data {
                    self.cities.append(city.name)
                    self.filteredCityNameList = self.cities
                }
                DispatchQueue.main.async {
                    self.cityButton.setTitle(self.filteredCityNameList[0], for: .normal)
                    self.cityNameLabel.text = self.filteredCityNameList[0]
                    self.cityListTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
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
        if collectionView == self.collectionView {
            let dataSource = dataSource.data[indexPath.item]
            coordinator?.goToProductDetailVC(dataSource: dataSource)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return dataSource.data.count
        } else {
            return homeDataSource.productCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
            cell.setup(image: homeDataSource.advertisementItems[indexPath.item].image,
                       text: dataSource.data[indexPath.item].name,
                       price: dataSource.data[indexPath.item].price)
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
        let textHeight = requiredHeight(text: dataSource.data[indexPath.item].name, cellWidth: cellWidth)
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
        cityButton.setTitle(filteredCityNameList[indexPath.row], for: .normal)
        cityNameLabel.text = filteredCityNameList[indexPath.row]
        
        citySearchView.isHidden = true
    }
}

//MARK: - extension HomeViewController: UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCityNameList = []
        if searchText == "" {
            filteredCityNameList = cities
        }
        for word in cities {
            if word.contains(searchText) {
                filteredCityNameList.append(word)
            }
        }
        self.cityListTableView.reloadData()
    }
}
