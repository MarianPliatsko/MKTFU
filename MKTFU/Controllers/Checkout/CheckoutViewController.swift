//
//  CheckoutViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-09.
//

import UIKit
import KeychainSwift

class CheckoutViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var product: Product?
    var user = User()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
    }
    
    //MARK: - IBAction
    
    @IBAction private func confirmBtnPressed(_ sender: UIButton) {
        if product != nil {
            purchaseListing(product: product!)
        }
    }
    
    //MARK: - Methods
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CheckoutTableViewCell.nib(),
                           forCellReuseIdentifier: CheckoutTableViewCell.identifier)
    }
    
    private func purchaseListing(product: Product) {
        NetworkManager.shared.request(endpoint: "\(EndpointConstants.purchaseListing)\(product.id)",
                                      type: Product.self,
                                      token: KeychainSwift().get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .put,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let product):
                DispatchQueue.main.async {
                    self?.coordinator?.goToPickupInformationViewController(user: self?.user ?? User(), with: product, with: .fromCheckout)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource

extension CheckoutViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckoutTableViewCell.identifier, for: indexPath) as? CheckoutTableViewCell else {return UITableViewCell()}
        if product != nil {
            cell.setupUI(product: product!)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
