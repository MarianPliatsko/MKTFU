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
    var dataSource: [String] = []
    var isSelectCity: (() -> Void)?
    var textInView: ((String) -> Void)?
    var rawValue = ""
    
    //MARK: - Outlet
    
    @IBOutlet weak var lpView: LpCustomViewWithButton!
    @IBOutlet weak var lpViewList: LPView!
    @IBOutlet weak var listTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        lpViewList.isHidden = true
        
        listTableView.delegate = self
        listTableView.dataSource = self
        
        listTableView.separatorStyle = .none
        
        listTableView.register(DetailListTableViewCell.nib(), forCellReuseIdentifier: DetailListTableViewCell.identifier)
        
        lpView.txtInputField.addTarget(self,
                                         action: #selector(NameTableViewCell.textFieldDidChange(_:)),
                                         for: .editingChanged)
    }

    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(title: String, placeholder: String, text: String, rawValue: String) {
        lpView?.title = title
        lpView.placeHolder = placeholder
        lpView.txtInputField.text = text
        self.rawValue = rawValue
    }
}

extension CellWithButtonTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = listTableView.dequeueReusableCell(withIdentifier: DetailListTableViewCell.identifier, for: indexPath) as! DetailListTableViewCell
        cell.setupUI(text: dataSource[indexPath.row])
        self.listTableView.reloadRows(at: [indexPath], with: .automatic)
        return cell
    }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.textInView?(rawValue)
        }
    }
