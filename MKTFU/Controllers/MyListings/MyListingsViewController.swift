//
//  MyListingsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import KeychainSwift

private enum Tab {
    case active
    case sold
}

struct ProductSection {
    var sectionTitle: String?
    var products: [Product]
}

class MyListingsViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var products: [Product] = []
    private var userActiveListingProducts: [Product] = []
    private var userPendingListingProducts: [Product] = []
    private var soldListingProducts: [Product] = []
    private var dataSource: [ProductSection] = []
    private var selectedTab: Tab = .active
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var soldItemsIndicator: UILabel! {
        didSet {
            soldItemsIndicator.layer.cornerRadius = soldItemsIndicator.bounds.width / 2
            soldItemsIndicator.clipsToBounds = true
        }
    }
    @IBOutlet weak var activeItemsButton: UIButton!
    @IBOutlet weak var soldItemsButton: UIButton!
    @IBOutlet private weak var myListingTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()

        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        getMyListing()
    }
    
    //MARK: - IBAction
    
    @IBAction private func activeItemsBtnPressed(_ sender: UIButton) {
        selectedTab = .active
        dataSource = []
        reloadDataSource()
    }
    
    @IBAction private func soldItemsBtbPressed(_ sender: UIButton) {
        selectedTab = .sold
        dataSource = []
        reloadDataSource()
    }
    
    //MARK: - Methods
    
    private func setupTableView() {
        myListingTableView.delegate = self
        myListingTableView.dataSource = self
        myListingTableView.register(MyListingTableViewCell.nib(),
                                    forCellReuseIdentifier: MyListingTableViewCell.identifier)
    }
    
    private func getMyListing() {
        NetworkManager.shared.request(endpoint: EndpointConstants.myListing,
                                      type: [Product].self,
                                      token: KeychainSwift().get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let listing):
                DispatchQueue.main.async {
                    self?.products = listing
                    guard self?.products != nil else {return}
                    for element in self!.products {
                        if element.status == "ACTIVE" {
                            self?.userActiveListingProducts.append(element)
                        }
                        if element.status == "PENDING" {
                            self?.userPendingListingProducts.append(element)
                        }
                        if element.status == "COMPLETE" {
                            self?.soldListingProducts.append(element)
                        }
                    }
                    self?.reloadDataSource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func reloadDataSource() {
        switch selectedTab {
        case .active:
            activeItemsSelected()
            if !userPendingListingProducts.isEmpty {
                dataSource.append(ProductSection(sectionTitle: "Pending Items",
                                                 products: userPendingListingProducts))
            }
            if !userActiveListingProducts.isEmpty {
                dataSource.append(ProductSection(sectionTitle: "Available Items",
                                                 products: userActiveListingProducts))
            }
        case .sold:
            soldItemsSelected()
            if !soldListingProducts.isEmpty {
                dataSource.append(ProductSection(sectionTitle: nil,
                                                 products: soldListingProducts))
            }
        }
        myListingTableView.reloadData()
    }
    
    private func activeItemsSelected() {
        activeItemsButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
        soldItemsButton.tintColor = UIColor.appColor(LPColor.TextGray)
    }
    
    private func soldItemsSelected() {
        activeItemsButton.tintColor = UIColor.appColor(LPColor.TextGray)
        soldItemsButton.tintColor = UIColor.appColor(LPColor.OccasionalPurple)
    }
}

    //MARK: - extension MyListingsViewController: UITableViewDelegate, UITableViewDataSource

extension MyListingsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = MyListingSectionHeaderView()
        view.setup(data: dataSource[section].sectionTitle ?? "")
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if dataSource[section].sectionTitle != nil {
            return 20
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myListingTableView.dequeueReusableCell(withIdentifier: MyListingTableViewCell.identifier, for: indexPath) as? MyListingTableViewCell else {return UITableViewCell()}
        cell.setup(product: dataSource[indexPath.section].products[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if dataSource[indexPath.section].products[indexPath.row].status == "ACTIVE" {
            coordinator?.goToCreateOfferVC(product: dataSource[indexPath.section].products[indexPath.row], with: .saveChanges)
        }
        if dataSource[indexPath.section].products[indexPath.row].status == "PENDING" {
            coordinator?.goToCreateOfferVC(product: dataSource[indexPath.section].products[indexPath.row], with: .confirmSold)
        }
    }
}
