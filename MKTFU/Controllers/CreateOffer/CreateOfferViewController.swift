//
//  CreateOfferViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-24.
//

import UIKit
import PhotosUI
import KeychainSwift

struct ImageCellViewModel {
    var images: [String]
    var onAddImageButtonTapped: (() -> Void)
    var onDeletePressed: ((String?) -> Void)
}

struct NameCellViewModel {
    var title: String
    var placeholder: String
    var text: String
    var nameTextInView: ((String) -> Void)
}

struct DescriptionCellViewModel {
    var title: String
    var text: String
    var descriptionTextInView: ((String) -> Void)
}

enum CreateOfferTableViewCellType: Int, CaseIterable {
    case productImagesCell = 0
    case productNameCell = 1
    case productDescriptionCell = 2
}

class CreateOfferViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    let keyChain = KeychainSwift()
    var imageId: [String] = []
    var product = Product()
    
    var createOfferDataSource = CreateOffer(category:
                                                Category(categoryList: ["Vehicles", "Furniture", "Electronics", "Real estate"]),
                                            condition:
                                                Condition(conditionList: ["New", "Used"]),
                                            city:
                                                City( cityList: ["Calgary", "Brook"]))
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        tableView.register(ProductImagesTableViewCell.nib(),
                           forCellReuseIdentifier: ProductImagesTableViewCell.identifier)
        tableView.register(NameTableViewCell.nib(),
                           forCellReuseIdentifier: NameTableViewCell.identifier)
        tableView.register(CellWithButtonTableViewCell.nib(),
                           forCellReuseIdentifier: CellWithButtonTableViewCell.identifier)
        tableView.register(ProductDescriptionTableViewCell.nib(),
                           forCellReuseIdentifier: ProductDescriptionTableViewCell.identifier)
        tableView.register(ConfirmTableViewCell.nib(),
                           forCellReuseIdentifier: ConfirmTableViewCell.identifier)
        tableView.register(CancelTableViewCell.nib(),
                           forCellReuseIdentifier: CancelTableViewCell.identifier)
    }
    
    //MARK: - Methods
    
    private func presentPhotoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        let pickerVC  = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
    
    private func createOffer(data:Product) {
        let parameters: [String:Any] = ["productName": data.productName,
                                        "description": data.description,
                                        "price": data.price,
                                        "category": data.category ?? "",
                                        "condition": data.condition ?? "",
                                        "address": data.address,
                                        "city": data.city,
                                        "images": data.images.map {($0 as NSString).lastPathComponent}]
        
        NetworkManager.shared.request(endpoint: "api/Product",
                                      type: Product.self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .post,
                                      resultsLimit: nil,
                                      parameters: parameters) { result in
            switch result {
            case .success(let success):
                print(success)
                DispatchQueue.main.async {
                    self.coordinator?.goToSuccessVC()
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
    
    private func createNameViewModel() -> NameCellViewModel {
        NameCellViewModel(title: "Product name",
                          placeholder: "Type your product name",
                          text: product.productName,
                          nameTextInView: { [weak self] text in
            self?.product.productName = text
        })
    }
    
    private func createDescriptionViewModel() -> DescriptionCellViewModel {
        DescriptionCellViewModel(title: "Description",
                                 text: product.description,
                                 descriptionTextInView: { [weak self] description in
            self?.product.description = description
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
            
            
        default:
            return UITableViewCell()
        }
        
        
        let cellWithButton = tableView.dequeueReusableCell(withIdentifier: CellWithButtonTableViewCell.identifier, for: indexPath) as? CellWithButtonTableViewCell
        
        let confirmCell = tableView.dequeueReusableCell(withIdentifier: ConfirmTableViewCell.identifier, for: indexPath) as? ConfirmTableViewCell
        
        let cancelCell = tableView.dequeueReusableCell(withIdentifier: CancelTableViewCell.identifier, for: indexPath) as? CancelTableViewCell
        
        if indexPath.row == 3 {
            cellWithButton?.setupUI(title: "Category",
                                    placeholder: "Choose your category",
                                    text: product.category?.localizedTitle ?? "",
                                    rawValue: product.category?.rawValue ?? "")
            cellWithButton?.dataSource = createOfferDataSource.category.categoryList
            
            cellWithButton?.textInView = { [weak self] text in
                self?.tableView.beginUpdates()
                self?.product.category = Categories(rawValue: text)
                cellWithButton?.lpViewList.isHidden = true
                self?.tableView.reloadData()
                self?.tableView.endUpdates()
            }
            
            cellWithButton?.listTableView.reloadData()
            
            cellWithButton?.lpView.onButtonPressed = { [weak self] in
                self?.tableView.beginUpdates()
                cellWithButton?.lpViewList.isHidden.toggle()
                self?.tableView.endUpdates()
            }
            return cellWithButton ?? UITableViewCell()
        }
        
        if indexPath.row == 4 {
            cellWithButton?.setupUI(title: "Condition",
                                    placeholder: "Choose the condotion",
                                    text: product.condition?.localizedTitle ?? "",
                                    rawValue: product.condition?.rawValue ?? "")
            cellWithButton?.dataSource = createOfferDataSource.condition.conditionList
            
            cellWithButton?.textInView = { [weak self] text in
                self?.tableView.beginUpdates()
                self?.product.condition = Conditions(rawValue: text)
                cellWithButton?.lpViewList.isHidden = true
                self?.tableView.reloadData()
                self?.tableView.endUpdates()
            }
            
            cellWithButton?.listTableView.reloadData()
            
            cellWithButton?.lpView.onButtonPressed = { [weak self] in
                self?.tableView.beginUpdates()
                cellWithButton?.lpViewList.isHidden.toggle()
                self?.tableView.endUpdates()
            }
            return cellWithButton ?? UITableViewCell()
        }
        
//        if indexPath.row == 5 {
//            cell?.setupUI(title: "Price",
//                          placeholder: "Type your price",
//                          text: product.price)
//            cell?.textInView = { [weak self] text in
//                self?.product.price = Double(text) ?? 0.0
//            }
//            return cell ?? UITableViewCell()
//        }
//        
//        if indexPath.row == 6 {
//            cell?.setupUI(title: "Address",
//                          placeholder: "Type your address",
//                          text: product.address)
//            cell?.textInView = { [weak self] text in
//                self?.product.address = text
//            }
//            return cell ?? UITableViewCell()
//        }
        
        if indexPath.row == 7 {
            cellWithButton?.setupUI(title: "City",
                                    placeholder: "Choose your city",
                                    text: product.city,
                                    rawValue: "")
            cellWithButton?.dataSource = createOfferDataSource.city.cityList
            cellWithButton?.textInView = { [weak self] text in
                self?.tableView.beginUpdates()
                self?.product.city = text
                cellWithButton?.lpViewList.isHidden = true
                self?.tableView.reloadData()
                self?.tableView.endUpdates()
            }
            
            cellWithButton?.listTableView.reloadData()
            
            cellWithButton?.lpView.onButtonPressed = { [weak self] in
                self?.tableView.beginUpdates()
                cellWithButton?.lpViewList.isHidden.toggle()
                self?.tableView.endUpdates()
            }
            return cellWithButton ?? UITableViewCell()
        }
        
        if indexPath.row == 8 {
            confirmCell?.onConfirmPressed = { [weak self] in
                if self?.product != nil {
                    self?.createOffer(data: (self?.product)!)
                }
            }
            return confirmCell ?? UITableViewCell()
        }
        if indexPath.row == 9 {
            return cancelCell ?? UITableViewCell()
        }
        return UITableViewCell()
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
