//
//  HomeViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-10.
//

import UIKit
import KeychainSwift

class HomeViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private let keyChain = KeychainSwift()
    private var filteredCityNameList: [String] = []
    var user = User()
    var products: [Product] = []
    
    let homeDataSource = Home(city: City.cities,
                              productCategory: [ProductCategory(name: "Deals",
                                                                image: UIImage(named: "Path 2") ?? UIImage()),
                                                ProductCategory(name: "Vehicles",
                                                                image: UIImage(named: "Path 4") ?? UIImage()),
                                                ProductCategory(name: "Furniture",
                                                                image: UIImage(named: "Path 7") ?? UIImage()),
                                                ProductCategory(name: "Electronics",
                                                                image: UIImage(named: "Path 9") ?? UIImage()),
                                                ProductCategory(name: "Real estate",
                                                                image: UIImage(named: "Path 5") ?? UIImage())])
    
    //MARK: - Outlets
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var headerCollectionView: UICollectionView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cityButton: UIButton!
    @IBOutlet private weak var citySearchView: UIView!
    @IBOutlet private weak var citySearchBar: UISearchBar!
    @IBOutlet private weak var cityListTableView: UITableView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var createListingView: UIControl! {
        didSet {
            createListingView.layer.cornerRadius = 25
            createListingView.clipsToBounds = true
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllProducts()
        
        cityButton.setTitle(homeDataSource.city[0].localizedTitle, for: .normal)
        cityNameLabel.text = cityButton.currentTitle
        
        for city in homeDataSource.city {
            filteredCityNameList.append(city.localizedTitle)
        }
//        filteredCityNameList = homeDataSource.city
        collectionView.delegate = self
        collectionView.dataSource = self
        
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        
        citySearchView.isHidden = true
        cityViewUISetup()
        
        cityListTableView.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
        
        headerCollectionView.register(HomeHeaderCollectionViewCell.nib(),forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.identifier)
        
        collectionView.register(HomeCollectionViewCell.nib(), forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        searchTextField.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        let layout = PinterestLayout()
        layout.delegate = self
        collectionView.collectionViewLayout = layout
        
        headerCollectionView.collectionViewLayout = headerLayoutConfig()
    }
    
    //MARK: - IBActions
    
    @IBAction private func createListingViewPressed(_ sender: Any) {
        coordinator?.goToCreateOfferVC(product: nil, with: .createProduct)
    }
    
    @IBAction private func searchOnMktfyBtnPressed(_ sender: Any) {
        if searchTextField.text?.isEmpty == false {
            guard let searchText = searchTextField.text else {return}
            guard let city = cityNameLabel.text else {return}
            searchProduct(searchKeyWords: searchText, city: city, category: nil)
        }
    }
    
    @IBAction private func cityButtonPressed(_ sender: UIButton) {
        citySearchView.isHidden = !citySearchView.isHidden
    }
    
    @IBAction private func menuButtonPressed(_ sender: UIButton) {
        coordinator?.goToMenuViewController(user: user)
    }
    
    // MARK: - Methods
    
    private func headerLayoutConfig() -> UICollectionViewCompositionalLayout {
        let item = CompositionLayout.createItem(width: .absolute(120),
                                                height: .fractionalHeight(1),
                                                spacing: 0)
        let group = CompositionLayout.createGroup(alignment: .horizontal,
                                                  width: .absolute(100),
                                                  height: .fractionalHeight(1),
                                                  item: item,
                                                  count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    private func cityViewUISetup() {
        citySearchView.layer.cornerRadius = 20
        citySearchView.clipsToBounds = true
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if searchTextField.text?.isEmpty == true {
            getAllProducts()
        }
    }
    
    private func getAllProducts() {
        NetworkManager.shared.request(endpoint: EndpointConstants.getAllProducts,
                                      type: [Product].self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    for products in products {
                        if products.status == "ACTIVE" {
                            self.products.append(products)
                        }
                    }
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getDeals(query: Int?) {
        NetworkManager.shared.request(endpoint: EndpointConstants.getDeals,
                                      type: [Product].self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: 20,
                                      parameters: nil) { result in
            switch result {
            case .success(let deals):
                DispatchQueue.main.async {
                    self.products = deals
                    self.products.sort {
                        $0.price < $1.price
                    }
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getProductsByCategory(category: String, city: String) {
        guard let category = Categories(rawValue: category) else {return}
        let parameters = ["category": category.localizedTitle,
                          "city": city]
        
        NetworkManager.shared.request(endpoint: EndpointConstants.productsByCategory,
                                      type: [Product].self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .post,
                                      resultsLimit: 50,
                                      parameters: parameters) { [weak self] result in
            switch result {
            case .success(let productsByCategory):
                DispatchQueue.main.async {
                    self?.products = productsByCategory
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func searchProduct(searchKeyWords: String, city: String, category: String?) {
        let parameters = ["search": searchKeyWords,
                          "city": city,
                          "category": nil]
        NetworkManager.shared.request(endpoint: EndpointConstants.searchProduct,
                                      type: [Product].self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .post,
                                      resultsLimit: nil,
                                      parameters: parameters as [String : Any]) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    self?.products = products
                    self?.collectionView.reloadData()
                }
                case .failure(let error):
                    print(error)
                }
            }
    }
}

//MARK: - extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            coordinator?.goToProductDetailVC(with: products[indexPath.item])
        } else {
            if indexPath.item == 0 {
                getDeals(query: 3)
            } else {
                getProductsByCategory(category: homeDataSource.productCategory[indexPath.item].name, city: cityButton.currentTitle ?? "")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return products.count
        } else {
            return homeDataSource.productCategory.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
            cell.getImage(from: products[indexPath.item].images)
            cell.setup(text: products[indexPath.item].productName,
                       price: products[indexPath.item].price)
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
        let imgHeight = calculateImageHeight(sourceImage: UIImage(named: "Path 2") ?? UIImage() , scaledToWidth: cellWidth)
        let textHeight = requiredHeight(text: products[indexPath.item].productName, cellWidth: cellWidth)
        return (imgHeight + textHeight + 5)
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
        cityButton.setTitle(homeDataSource.city[indexPath.row].localizedTitle, for: .normal)
        cityNameLabel.text = homeDataSource.city[indexPath.row].localizedTitle
        getProductsByCategory(category: homeDataSource.productCategory[indexPath.item].name, city: cityButton.currentTitle ?? "")
        citySearchView.isHidden = true
    }
}

//MARK: - extension HomeViewController: UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCityNameList = []
        if searchText == "" {
            for city in homeDataSource.city {
                filteredCityNameList.append(city.localizedTitle)
            }
        }
        for word in homeDataSource.city {
            if word.localizedTitle.contains(searchText) {
                filteredCityNameList.append(word.localizedTitle)
            }
        }
        self.cityListTableView.reloadData()
    }
}
