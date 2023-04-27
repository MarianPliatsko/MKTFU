//
//  HomeViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-10.
//

import UIKit
import KeychainSwift
import Kingfisher

class HomeViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private let keyChain = KeychainSwift()
    private var filteredCityNameList: [String] = []
    var user = User()
    var products: [Product] = []
    private var categories: [Categories] = []
    private let homeDataSource = Home(city: City.cities,
                                      productImage: ProductImage.images)
    
    //MARK: - Outlets
    
    @IBOutlet private weak var searchTextField: UITextField!
    @IBOutlet private weak var headerCollectionView: UICollectionView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var cityButton: UIButton!
    @IBOutlet private weak var citySearchView: UIView!
    @IBOutlet private weak var citySearchBar: UISearchBar!
    @IBOutlet private weak var cityListTableView: UITableView!
    @IBOutlet private weak var cityNameLabel: UILabel!
    @IBOutlet private weak var createListingView: UIControl!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        getAllProducts()
        setupCollectionViews()
        setupTableView()
        setupSearchCityViewUI()
        setupTextField()
        setupFilteredCitiesArray()
    }
    
    //MARK: - IBActions
    
    @IBAction private func createListingViewPressed(_ sender: Any) {
        coordinator?.goToCreateOfferVC(user: user, product: nil, with: .createProduct)
    }
    
    @IBAction private func searchOnMktfyBtnPressed(_ sender: Any) {
        if searchTextField.text?.isEmpty == false {
            guard let searchText = searchTextField.text else {return}
            guard let city = cityNameLabel.text else {return}
            searchProduct(searchKeyWords: searchText, city: city, category: nil)
        }
    }
    
    @IBAction private func cityButtonPressed(_ sender: UIButton) {
        citySearchView.isHidden.toggle()
    }
    
    @IBAction private func menuButtonPressed(_ sender: UIButton) {
        coordinator?.goToMenuViewController(user: user)
    }
    
    // MARK: - Methods
    
    private func setupFilteredCitiesArray() {
        for city in homeDataSource.city {
            filteredCityNameList.append(city.localizedTitle)
        }
    }
    
    private func setupUI() {
        createListingView.layer.cornerRadius = 25
        createListingView.clipsToBounds = true
        cityButton.setTitle(homeDataSource.city[0].localizedTitle, for: .normal)
        cityNameLabel.text = cityButton.currentTitle
    }
    
    private func setupSearchCityViewUI() {
        citySearchView.isHidden = true
        citySearchView.layer.cornerRadius = 20
        citySearchView.clipsToBounds = true
    }
    
    private func setupTextField() {
        searchTextField.addTarget(
            self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupCollectionViews() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HomeCollectionViewCell.nib(),
                                forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        headerCollectionView.delegate = self
        headerCollectionView.dataSource = self
        headerCollectionView.setCollectionViewLayout(
            UICollectionViewCompositionalLayout.createLayout(itemWidth: .absolute(120),
                                                             itemHeight: .fractionalHeight(1),
                                                             groupWidth: .absolute(100),
                                                             groupHeight: .fractionalHeight(1)), animated: false)
        headerCollectionView.register(HomeHeaderCollectionViewCell.nib(),
                                      forCellWithReuseIdentifier: HomeHeaderCollectionViewCell.identifier)
    }
    
    private func setupTableView() {
        cityListTableView.delegate = self
        cityListTableView.dataSource = self
        cityListTableView.register(HomeTableViewCell.nib(), forCellReuseIdentifier: HomeTableViewCell.identifier)
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        if searchTextField.text?.isEmpty == true {
            getAllProducts()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                guard let searchText = self?.searchTextField.text else {return}
                guard let city = self?.cityNameLabel.text else {return}
                self?.searchProduct(searchKeyWords: searchText, city: city, category: nil)
            }
        }
    }
    
    private func getAllProducts() {
        NetworkManager.shared.request(endpoint: EndpointConstants.getAllProducts,
                                      type: [Product].self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let products):
                DispatchQueue.main.async {
                    for products in products {
                        if products.status == "ACTIVE" {
                            self?.products.append(products)
                        }
                    }
                    self?.collectionView.reloadData()
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
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let deals):
                DispatchQueue.main.async {
                    self?.products = deals
                    self?.products.sort {
                        $0.price < $1.price
                    }
                    self?.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getProductsByCategory(category: Categories, city: String) {
        let category = category.rawValue
        let parameters = ["category": category,
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
        switch collectionView == self.collectionView {
        case true:
            coordinator?.goToProductDetailVC(user: user, with: products[indexPath.item])
        case false:
            switch indexPath.item {
            case 0:
                getDeals(query: 3)
            default:
                categories = Categories.allCases
                getProductsByCategory(category: categories[indexPath.item - 1],
                                      city: cityButton.currentTitle ?? "")
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView == self.collectionView {
        case true:
            return products.count
        case false:
            return Categories.allCases.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath) as? HomeCollectionViewCell else {return UICollectionViewCell()}
            cell.getImage(from: products[indexPath.item].images)
            cell.setup(text: products[indexPath.item].productName,
                       price: products[indexPath.item].price)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeHeaderCollectionViewCell.identifier, for: indexPath) as? HomeHeaderCollectionViewCell else {return UICollectionViewCell()}
            switch indexPath.item {
            case 0:
                cell.setupHeader(image: homeDataSource.productImage[indexPath.item].image,
                                 text: "Deals")
            default:
                cell.setupHeader(image: homeDataSource.productImage[indexPath.item].image,
                                 text: Categories.allCases[indexPath.item - 1].localizedTitle)
            }
            return cell
        }
    }
}

//MARK: - extension HomeViewController: UICollectionViewDelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let spacing = flowLayout?.minimumInteritemSpacing ?? 0
        let sectionInset = flowLayout?.sectionInset ?? .zero
        return CGSize(width: (self.collectionView.frame.width - spacing) / 2 - sectionInset.left - sectionInset.right,
                      height: 220)
    }
}

//MARK: - extension HomeViewController: UITableViewDelegate, UITableViewDataSource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCityNameList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
        cell.setupUI(city: filteredCityNameList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cityButton.setTitle(homeDataSource.city[indexPath.row].localizedTitle, for: .normal)
        cityNameLabel.text = homeDataSource.city[indexPath.row].localizedTitle
        getProductsByCategory(category: Categories.allCases[indexPath.item],
                              city: cityButton.currentTitle ?? "")
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
