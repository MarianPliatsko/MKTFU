//
//  MyPurchasesViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import KeychainSwift

class MyPurchasesViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var product: [Product] = []
    var user = User()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
         
        getMyPurchases()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyPurchasesTableViewCell.nib(),
                           forCellReuseIdentifier: MyPurchasesTableViewCell.identifier)
    }
    
    private func getMyPurchases() {
        NetworkManager.shared.request(endpoint: EndpointConstants.myPurcases,
                                      type: [Product].self,
                                      token: KeychainSwift().get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let purchases):
                DispatchQueue.main.async {
                    self?.product = purchases
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MyPurchasesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return product.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPurchasesTableViewCell.identifier, for: indexPath) as? MyPurchasesTableViewCell else {return UITableViewCell()}
        cell.setup(product: product[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.goToPickupInformationViewController(user: user, with: product[indexPath.row], with: .fromPurchases)
    }
}
