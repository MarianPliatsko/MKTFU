//
//  CreateOfferViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-24.
//

import UIKit
import PhotosUI

class CreateOfferViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    let createOfferDataSource = CreateOffer(images: [],
                                   productName: ["Product name" , "Description", "Category", "Condition", "Price", "Adress", "City"],
                                   description: "productName",
                                   category:
                                    Category(categoryName: "categoryName",
                                             categotyLblPlaceholder: "categotyLblPlaceholder",
                                             categoryList: ["New", "Used"]),
                                   condition:
                                    Condition(conditionName: "conditionName",
                                              conditionLblPlaceholder: "conditionLblPlaceholder",
                                              conditionList: ["conditionList"]),
                                   price: 100,
                                   adress: "category",
                                   city:
                                    City( cityList: ["cityList"]),
                                   isShow: false)
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        cellWithButton.listStackView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        tableView.register(AddImageTableViewCell.nib(),
                           forCellReuseIdentifier: AddImageTableViewCell.identifier)
        tableView.register(MainTableViewCell.nib(),
                           forCellReuseIdentifier: MainTableViewCell.identifier)
        tableView.register(CellWithButtonTableViewCell.nib(),
                           forCellReuseIdentifier: CellWithButtonTableViewCell.identifier)
        tableView.register(CellWithTextViewTableViewCell.nib(),
                           forCellReuseIdentifier: CellWithTextViewTableViewCell.identifier)
        tableView.register(ConfirmTableViewCell.nib(),
                           forCellReuseIdentifier: ConfirmTableViewCell.identifier)
        tableView.register(CancelTableViewCell.nib(),
                           forCellReuseIdentifier: CancelTableViewCell.identifier)
    }
    
    func photoPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.selectionLimit = 3
        config.filter = .images
        let pickerVC  = PHPickerViewController(configuration: config)
        pickerVC.delegate = self
        self.present(pickerVC, animated: true)
    }
}

//MARK: - CreateOfferViewController: UITableViewDelegate, UITableViewDataSource

extension CreateOfferViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellwithImage = tableView.dequeueReusableCell(withIdentifier: AddImageTableViewCell.identifier, for: indexPath) as? AddImageTableViewCell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as? MainTableViewCell
        
        let cellWithTextView = tableView.dequeueReusableCell(withIdentifier: CellWithTextViewTableViewCell.identifier, for: indexPath) as? CellWithTextViewTableViewCell
        
        let cellWithButton = tableView.dequeueReusableCell(withIdentifier: CellWithButtonTableViewCell.identifier, for: indexPath) as? CellWithButtonTableViewCell
        
        let confirmCell = tableView.dequeueReusableCell(withIdentifier: ConfirmTableViewCell.identifier, for: indexPath) as? ConfirmTableViewCell
        
        let cancelCell = tableView.dequeueReusableCell(withIdentifier: CancelTableViewCell.identifier, for: indexPath) as? CancelTableViewCell
        
        if indexPath.row == 0 {
            if createOfferDataSource.images.count == 0 {
                cellwithImage?.images = createOfferDataSource.images
                cellwithImage?.onNeedUpdate = { [weak self] in
                    DispatchQueue.main.async {
                        self?.photoPicker()
                        self?.tableView.reloadData()
//                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                cellwithImage?.stackViewWithImage.isHidden = true
                cellwithImage?.emptyStackView.isHidden = false
            }
            else {
                cellwithImage?.dataSourceUpdate = { [weak self] images in
                    self?.createOfferDataSource.images = images
                }
                cellwithImage?.stackViewWithImage.isHidden = false
                cellwithImage?.emptyStackView.isHidden = true
                cellwithImage?.images = createOfferDataSource.images
                cellwithImage?.onNeedUpdate = {[weak self] in
                    DispatchQueue.main.async {
                        self?.photoPicker()
                        self?.tableView.reloadData()
//                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
                
            }
            // reload table view after delete image button pressed to change ui for table view
            cellwithImage?.onDeletePressed = { [weak self] in
                self?.tableView.reloadData()
            }
            return cellwithImage ?? UITableViewCell()
        }
        
        if indexPath.row == 1 {
            cell?.lpUIView.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            cell?.lpUIView.placeHolder = "Type your product name"
            return cell ?? UITableViewCell()
        }
        if indexPath.row == 2 {
            cellWithTextView?.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            return cellWithTextView ?? UITableViewCell()
        }
        if indexPath.row == 3 {
            cellWithButton?.lpView.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            cellWithButton?.dataSource = createOfferDataSource.category.categoryList
            cellWithButton?.listTableView.reloadData()
            cellWithButton?.lpViewList.isHidden = !createOfferDataSource.isShow
            cellWithButton?.lpView.isHidden = createOfferDataSource.isShow
            
            cellWithButton?.isSelect = { [weak self] in
                self?.createOfferDataSource.isShow.toggle()
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cellWithButton?.lpView.placeHolder = "Choose your category"
            
            return cellWithButton ?? UITableViewCell()
        }
        if indexPath.row == 4 {
            cellWithButton?.lpView.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            cellWithButton?.dataSource = createOfferDataSource.condition.conditionList
            cellWithButton?.listTableView.reloadData()
            cellWithButton?.lpViewList.isHidden = !createOfferDataSource.isShow
            cellWithButton?.lpView.isHidden = createOfferDataSource.isShow
            
            cellWithButton?.isSelect = { [weak self] in
                self?.createOfferDataSource.isShow.toggle()
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cellWithButton?.lpView.placeHolder = "Choose the condotion"
            
            return cellWithButton ?? UITableViewCell()
        }
        if indexPath.row == 5 {
            cell?.lpUIView.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            cell?.lpUIView.placeHolder = "Type your price"
            return cell ?? UITableViewCell()
        }
        if indexPath.row == 6 {
            cell?.lpUIView.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            cell?.lpUIView.placeHolder = "Type your address"
            return cell ?? UITableViewCell()
        }
        if indexPath.row == 7 {
            cellWithButton?.lpView.lblTitle.text = createOfferDataSource.productName[indexPath.row - 1]
            cellWithButton?.dataSource = createOfferDataSource.city.cityList
            cellWithButton?.listTableView.reloadData()
            cellWithButton?.lpViewList.isHidden = !createOfferDataSource.isShow
            cellWithButton?.lpView.isHidden = createOfferDataSource.isShow
            
            cellWithButton?.isSelect = { [weak self] in
                self?.createOfferDataSource.isShow.toggle()
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            cellWithButton?.lpView.lblTitle.text = "Choose your city"
            
            return cellWithButton ?? UITableViewCell()
        }
        if indexPath.row == 8 {
            confirmCell?.onConfirmPressed = { [weak self] in
                self?.coordinator?.goToSuccessVC()
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
                    self.createOfferDataSource.images.append(image)
            }
        }
        group.notify(queue: .main) {
            print(self.createOfferDataSource.images.count)
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
