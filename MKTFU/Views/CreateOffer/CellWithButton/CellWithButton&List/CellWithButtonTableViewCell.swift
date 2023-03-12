//
//  MainWithButtonTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import UIKit

class CellWithButtonTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "MainWithButtonTableViewCell"
    let model1 = Condition(conditionName: "Model1",
                          conditionLblPlaceholder: "Model1",
                          conditionList: ["1", "2", "3"])
    let model2 = Condition(conditionName: "Model2",
                          conditionLblPlaceholder: "Model2",
                          conditionList: ["4", "5", "6"])
    let model3 = Condition(conditionName: "Model3",
                          conditionLblPlaceholder: "Model3",
                          conditionList: ["7", "8", "9"])
    
    var isSelect: (() -> Void)?
    
    //MARK: - Outlet
    
    @IBOutlet weak var lpView: LpCustomViewWithButton!
    @IBOutlet weak var lpViewList: LPView!
    @IBOutlet weak var listTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.separatorStyle = .none
        
        lpView.txtInputField.delegate = self
        
        listTableView.register(DetailListTableViewCell.nib(), forCellReuseIdentifier: DetailListTableViewCell.identifier)
    }

    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
//    func setupUI(data: CreateOffer, indexPath: IndexPath) {
//        lpView?.title = data.productName[indexPath.row]
//    }
}

extension CellWithButtonTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = listTableView.dequeueReusableCell(withIdentifier: DetailListTableViewCell.identifier, for: indexPath) as! DetailListTableViewCell
            //cell.setupUI(text: dataSource.condition.conditionList[indexPath.row])
            cell.setupUI(text: "yo")
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.isSelect?()
        }
    }

extension CellWithButtonTableViewCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.isSelect?()
    }
}
