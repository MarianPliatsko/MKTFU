//
//  CheckoutViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-09.
//

import UIKit

class CheckoutViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var product: Product?
    
    //MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckoutTableViewCell.nib(),
                           forCellReuseIdentifier: CheckoutTableViewCell.identifier)
    }
    
    //MARK: - IBAction
    
    
    @IBAction func confirmBtnPressed(_ sender: UIButton) {
        if product != nil {
            self.coordinator?.goToPickupInformationViewController(with: product!)
        }
    }
}



extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.identifier, for: indexPath) as? CheckoutTableViewCell else {return UITableViewCell()}
        cell.setupUI(image: product?.images[0] ?? "",
                     title: product?.productName ?? "",
                     price: product?.price ?? 0.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
