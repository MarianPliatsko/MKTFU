//
//  CreateOfferViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-24.
//

import UIKit
import PhotosUI
import KeychainSwift

private enum CreateOfferTableViewCellType: Int, CaseIterable {
    case productImagesCell = 0
    case productNameCell = 1
    case productDescriptionCell = 2
    case productCategoryCell = 3
    case productConditionCell = 4
    case productPriceCell = 5
    case productAddressCell = 6
    case poductCityCell = 7
    case confirmButtonCell = 8
    case cancelButtonCell = 9
}

enum Mode {
    case createProduct
    case saveChanges
    case confirmSold
}

class CreateOfferViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private let keyChain = KeychainSwift()
    var product = Product()
    var mode: Mode!
    private var createOfferDataSource = CreateOffer(category:
                                                        Category(categoryList: ["Vehicles", "Furniture", "Electronics", "Real estate"]),
                                                    condition:
                                                        Condition(conditionList: ["New", "Used"]),
                                                    city:
                                                        City( cityList: ["Calgary", "Brook"]))
    
    //MARK: - Outlet
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var tableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Methods
    
    private func setupMode(mode: Mode) {
        self.mode = mode
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ProductImagesTableViewCell.nib(),
                           forCellReuseIdentifier: ProductImagesTableViewCell.identifier)
        tableView.register(NameTableViewCell.nib(),
                           forCellReuseIdentifier: NameTableViewCell.identifier)
        tableView.register(ProductCategoryConditionCityTableViewCell.nib(),
                           forCellReuseIdentifier: ProductCategoryConditionCityTableViewCell.identifier)
        tableView.register(ProductDescriptionTableViewCell.nib(),
                           forCellReuseIdentifier: ProductDescriptionTableViewCell.identifier)
        tableView.register(ConfirmTableViewCell.nib(),
                           forCellReuseIdentifier: ConfirmTableViewCell.identifier)
        tableView.register(CancelTableViewCell.nib(),
                           forCellReuseIdentifier: CancelTableViewCell.identifier)
    }
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        let pickerVC  = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    private func confirmSold(data: Product) {
        NetworkManager.shared.request(endpoint: "\(EndpointConstants.confirmSold)\(data.id)",
                                      type: Product.self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .put,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let product):
                print(product)
                DispatchQueue.main.async {
                    self?.coordinator?.goToSuccessVC()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateOffer(data: Product) {
        guard let category = data.category?.rawValue else {return}
        guard let condition = data.condition?.rawValue else {return}
        let parameters: [String:Any] = ["id": data.id,
                                        "productName": data.productName,
                                        "description": data.description,
                                        "price": data.price,
                                        "category": category,
                                        "condition": condition,
                                        "address": data.address,
                                        "city": data.city,
                                        "images": data.images.map {($0 as NSString).lastPathComponent}]
        
        NetworkManager.shared.request(endpoint: EndpointConstants.updateListing,
                                      type: Product.self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .put,
                                      resultsLimit: nil,
                                      parameters: parameters) { [weak self] result in
            switch result {
            case .success(_):
                print("Product was successfuly updated")
                DispatchQueue.main.async {
                    self?.coordinator?.goToMyListingsViewController()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createOffer(data:Product) {
        guard let category = data.category?.localizedTitle else {return}
        guard let condition = data.condition?.localizedTitle else {return}
        let parameters: [String:Any] = ["productName": data.productName,
                                        "description": data.description,
                                        "price": data.price,
                                        "category": category,
                                        "condition": condition,
                                        "address": data.address,
                                        "city": data.city,
                                        "images": data.images.map {($0 as NSString).lastPathComponent}]
        
        NetworkManager.shared.request(endpoint: "api/Product",
                                      type: Product.self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .post,
                                      resultsLimit: nil,
                                      parameters: parameters) { [weak self] result in
            switch result {
            case .success(let success):
                print(success)
                DispatchQueue.main.async {
                    self?.coordinator?.goToSuccessVC()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createImageCellViewModel() -> ImageCellViewModel {
        ImageCellViewModel(images: product.images,
                           onAddImageButtonTapped: { [weak self] in
            self?.presentPhotoPicker()
        },
                           onDeletePressed: { [weak self] image in
            if let image, let index = self?.product.images.firstIndex(of: image) {
                self?.product.images.remove(at: index)
                self?.tableView.reloadData()
            }
        })
    }
    
    private func createNameViewModel() -> NamePriceAddressCellViewModel {
        NamePriceAddressCellViewModel(title: "Product name",
                                      placeholder: "Type your product name",
                                      text: product.productName,
                                      nameTextInView: { [weak self] text in
            self?.product.productName = text as? String ?? ""
        })
    }
    
    private func createDescriptionViewModel() -> DescriptionCellViewModel {
        DescriptionCellViewModel(title: "Description",
                                 text: product.description,
                                 descriptionTextInView: { [weak self] description in
            self?.product.description = description
        })
    }
    
    private func createPriceViewModel() -> NamePriceAddressCellViewModel {
        NamePriceAddressCellViewModel(title: "Price",
                                      placeholder: "Type the price",
                                      text: product.price,
                                      nameTextInView: { [weak self] text in
            self?.product.price = text as? Double ?? 0.0
        })
    }
    
    private func createAddressViewModel() -> NamePriceAddressCellViewModel {
        NamePriceAddressCellViewModel(title: "Address",
                                      placeholder: "Type the address",
                                      text: product.address,
                                      nameTextInView: { [weak self] text in
            self?.product.address = text as? String ?? ""
        })
    }
    
    private func createCategoryViewModel() -> CategoryConditionCityCellViewModel {
        CategoryConditionCityCellViewModel(title: "Category",
                                           placeholder: "Choose the category",
                                           text: product.category?.localizedTitle ?? "",
                                           rawValue: product.category?.rawValue ?? "",
                                           categories: createOfferDataSource.category.categoryList,
                                           textInView: { [weak self] text in
            self?.tableView.beginUpdates()
            self?.product.category = Categories(rawValue: text)
            self?.tableView.reloadData()
            self?.tableView.endUpdates()
        },
                                           onButtonPressed: { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        })
    }
    private func createConditionViewModel() -> CategoryConditionCityCellViewModel {
        CategoryConditionCityCellViewModel(title: "Condition",
                                           placeholder: "Choose the condition",
                                           text: product.condition?.localizedTitle ?? "",
                                           rawValue: product.condition?.rawValue ?? "",
                                           categories: createOfferDataSource.condition.conditionList,
                                           textInView: { [weak self] text in
            self?.tableView.beginUpdates()
            self?.product.condition = Conditions(rawValue: text)
            self?.tableView.reloadData()
            self?.tableView.endUpdates()
        },
                                           onButtonPressed: { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        })
    }
    
    private func createCityViewMoodel() -> CategoryConditionCityCellViewModel {
        CategoryConditionCityCellViewModel(title: "City",
                                           placeholder: "Choose the city",
                                           text: product.city,
                                           rawValue: "",
                                           categories: createOfferDataSource.city.cityList,
                                           textInView: { [weak self] text in
            self?.tableView.beginUpdates()
            self?.product.city = text
            self?.tableView.reloadData()
            self?.tableView.endUpdates()
        },
                                           onButtonPressed: { [weak self] in
            self?.tableView.beginUpdates()
            self?.tableView.endUpdates()
        })
    }
}

//MARK: - CreateOfferViewController: UITableViewDelegate, UITableViewDataSource

extension CreateOfferViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateOfferTableViewCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = CreateOfferTableViewCellType.allCases[indexPath.item]
        
        switch cellType {
        case .productImagesCell:
            guard let productImagesCell = tableView.dequeueReusableCell(
                withIdentifier: ProductImagesTableViewCell.identifier,
                for: indexPath) as? ProductImagesTableViewCell else {return UITableViewCell()}
            let imageCellViewModel = createImageCellViewModel()
            productImagesCell.setup(model: imageCellViewModel)
            return productImagesCell
            
        case .productNameCell:
            guard let productNameCell = tableView.dequeueReusableCell(
                withIdentifier: NameTableViewCell.identifier,
                for: indexPath) as? NameTableViewCell else {return UITableViewCell()}
            let productNameCellViewModel = createNameViewModel()
            productNameCell.setup(model: productNameCellViewModel)
            return productNameCell
            
        case .productDescriptionCell:
            guard let descriptionCell = tableView.dequeueReusableCell(
                withIdentifier: ProductDescriptionTableViewCell.identifier,
                for: indexPath) as? ProductDescriptionTableViewCell else {return UITableViewCell()}
            let descriptionCellViewModel = createDescriptionViewModel()
            descriptionCell.setup(model: descriptionCellViewModel)
            return descriptionCell
            
        case .productCategoryCell:
            guard let categoryCell = tableView.dequeueReusableCell(
                withIdentifier: ProductCategoryConditionCityTableViewCell.identifier,
                for: indexPath) as? ProductCategoryConditionCityTableViewCell else {return UITableViewCell()}
            let categoryCellViewModel = createCategoryViewModel()
            categoryCell.setup(model: categoryCellViewModel)
            return categoryCell
            
        case .productConditionCell:
            guard let conditionCell = tableView.dequeueReusableCell(
                withIdentifier: ProductCategoryConditionCityTableViewCell.identifier,
                for: indexPath) as? ProductCategoryConditionCityTableViewCell else {return UITableViewCell()}
            let contionCellViewModel = createConditionViewModel()
            conditionCell.setup(model: contionCellViewModel)
            return conditionCell
            
        case .productPriceCell:
            guard let productPriceCell = tableView.dequeueReusableCell(
                withIdentifier: NameTableViewCell.identifier,
                for: indexPath) as? NameTableViewCell else {return UITableViewCell()}
            let productPriceCellViewModel = createPriceViewModel()
            productPriceCell.setup(model: productPriceCellViewModel)
            return productPriceCell
            
        case .productAddressCell:
            guard let productAdressCell = tableView.dequeueReusableCell(
                withIdentifier: NameTableViewCell.identifier,
                for: indexPath) as? NameTableViewCell else {return UITableViewCell()}
            let productAddressCellViewModel = createAddressViewModel()
            productAdressCell.setup(model: productAddressCellViewModel)
            return productAdressCell
            
        case .poductCityCell:
            guard let cityCell = tableView.dequeueReusableCell(
                withIdentifier: ProductCategoryConditionCityTableViewCell.identifier,
                for: indexPath) as? ProductCategoryConditionCityTableViewCell else {return UITableViewCell()}
            let productCityViewModel = createCityViewMoodel()
            cityCell.setup(model: productCityViewModel)
            return cityCell
            
        case .confirmButtonCell:
            guard let confirmCell = tableView.dequeueReusableCell(
                withIdentifier: ConfirmTableViewCell.identifier,
                for: indexPath) as? ConfirmTableViewCell else {return UITableViewCell()}
            confirmCell.setupUI(mode: mode)
            confirmCell.onConfirmPressed = { [weak self] in
                if self?.product != nil {
                    switch self?.mode {
                    case .createProduct:
                        self?.createOffer(data: (self?.product)!)
                    case .confirmSold:
                        self?.confirmSold(data: (self?.product)!)
                    case .saveChanges:
                        self?.updateOffer(data: (self?.product)!)
                    case .none:
                        break
                    }
                }
            }
            return confirmCell
            
        case .cancelButtonCell:
            guard let cancelCell = tableView.dequeueReusableCell(
                withIdentifier: CancelTableViewCell.identifier,
                for: indexPath) as? CancelTableViewCell else {return UITableViewCell()}
            return cancelCell
        }
    }
}

//MARK: - extension CreateOfferViewController: PHPickerViewControllerDelegate

extension CreateOfferViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let group = DispatchGroup()
        
        results.forEach { result in
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { reading, error in
                defer {
                    group.leave()
                }
                guard let image = reading as? UIImage, error == nil else { return }
                guard let token = self.keyChain.get(KeychainConstants.accessTokenKey) else {return}
                NetworkManager.shared.getImageId(for: image,
                                                 token: token,
                                                 type: [ImageId].self,
                                                 endpoint: "api/Upload") { result in
                    switch result {
                    case .success(let imageId):
                        print(imageId)
                        DispatchQueue.main.async {
                            for image in imageId {
                                self.product.images.append(
                                    "https://mktfy-proof-staging.s3.ca-central-1.amazonaws.com/\(image.id)")
                                self.tableView.reloadData()
                            }
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
        group.notify(queue: .main) {
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
