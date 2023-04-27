//
//  ProductCategoryConditionCityTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import UIKit

class ProductCategoryConditionCityTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "ProductCategoryConditionCityTableViewCell"
    private var categories: [PickerItem] = []
    private var textInView: ((String) -> Void)?
    private var rawValue = ""
    
    //MARK: - Outlet
    
    @IBOutlet private weak var lpView: LpCustomViewWithButton!
    @IBOutlet private weak var lpViewList: LPView!
    @IBOutlet private weak var listTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lpViewList.isHidden = true
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.separatorStyle = .none
        
        listTableView.register(DetailListTableViewCell.nib(), forCellReuseIdentifier: DetailListTableViewCell.identifier)
    }

    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(model: CategoryConditionCityCellViewModel) {
        lpView?.title = model.title
        lpView.placeHolder = model.placeholder
        lpView.txtInputField.text = model.text
        categories = model.pickerItems
        rawValue = model.rawValue
        textInView = model.textInView
        lpView.onButtonPressed = {
            self.lpViewList.isHidden.toggle()
            model.onButtonPressed()
        }
        if model.isDisabled {
            lpView.txtInputField.textColor = UIColor.appColor(LPColor.TextGray40)
            lpView.txtInputField.isEnabled = false
        }
        listTableView.reloadData()
    }
}

extension ProductCategoryConditionCityTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: DetailListTableViewCell.identifier, for: indexPath) as! DetailListTableViewCell
        cell.setupUI(data: categories[indexPath.row])
        return cell
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.textInView?(categories[indexPath.row].rawValue)
            lpViewList.isHidden = true
        }
    }
