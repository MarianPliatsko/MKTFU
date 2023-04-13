//
//  MyListingsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import KeychainSwift

class MyListingsViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var products: [Product] = []
    var userActiveListingProducts: [Product] = []
    var userPendingListingProducts: [Product] = []
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var soldItemsIndicator: UILabel! {
        didSet {
            soldItemsIndicator.layer.cornerRadius = soldItemsIndicator.bounds.width / 2
            soldItemsIndicator.clipsToBounds = true
        }
    }
    @IBOutlet weak var myListingTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myListingTableView.delegate = self
        myListingTableView.dataSource = self
        
        myListingTableView.register(MyListingTableViewCell.nib(),
                                    forCellReuseIdentifier: MyListingTableViewCell.identifier)

        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        filterUserListingsProducts(products: products)
    }
    
    //MARK: - IBAction
    
    @IBAction func activeItemsBtnPressed(_ sender: UIButton) {
        
        self.myListingTableView.reloadData()
    }
    
    
    @IBAction func soldItemsBtbPressed(_ sender: UIButton) {
        
        self.myListingTableView.reloadData()
    }
    
    
    //MARK: - Methods
    
    func filterUserListingsProducts(products: [Product]) {
        let userId = KeychainSwift().get(KeychainConstants.userIDKey)
        for element in products {
            if element.userId == userId {
                if element.status == "ACTIVE" {
                    userActiveListingProducts.append(element)
                }
                if element.status == "PENDING" {
                    userPendingListingProducts.append(element)
                }
            }
        }
    }
}

    //MARK: - extension MyListingsViewController: UITableViewDelegate, UITableViewDataSource
extension MyListingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return nil
        case 1:
            return MyListingSectionHeaderView()
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 0
        case 1:
            return 20
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return userPendingListingProducts.count
        case 1:
            return userActiveListingProducts.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myListingTableView.dequeueReusableCell(withIdentifier: MyListingTableViewCell.identifier, for: indexPath) as? MyListingTableViewCell else {return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            cell.setup(product: userPendingListingProducts[indexPath.row])
        case 1:
            cell.setup(product: userActiveListingProducts[indexPath.row])
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            coordinator?.goToCreateOfferVC(product: userPendingListingProducts[indexPath.row])
        case 1:
            coordinator?.goToCreateOfferVC(product: userActiveListingProducts[indexPath.row])
        default:
            break
        }
        
    }
}
