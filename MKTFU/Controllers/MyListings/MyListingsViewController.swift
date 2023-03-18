//
//  MyListingsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit

class MyListingsViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    var headreSoldItemsSection: [MyList] = []
    var headerAvalilableItemsSection: [MyList] = [MyList(image: UIImage(named: "3") ?? UIImage(),
                                                         date: .now,
                                                         name: "Item 3",
                                                         price: "300",
                                                         usedCondition: false)]
    var headerItemsSection : [MyList] = []
    
    var availableItemsSection: [MyList] = []
    
    var activeItems: [MyList] = [MyList(image: UIImage(named: "4") ?? UIImage(),
                                        date: .now,
                                        name: "Veeeeeeery Looooooooong name of Item 4",
                                        price: "400",
                                        usedCondition: true),
                                 MyList(image: UIImage(named: "5") ?? UIImage(),
                                        date: .now,
                                        name: "Item 5",
                                        price: "500",
                                        usedCondition: false)]
    var soldItems: [MyList] = [MyList(image: UIImage(named: "1") ?? UIImage(),
                                      date: .now,
                                      name: "Veeeeeeery Looooooooong name of Item 1",
                                      price: "100",
                                      usedCondition: false),
                               MyList(image: UIImage(named: "2") ?? UIImage(),
                                      date: .now,
                                      name: "Item 2",
                                      price: "200",
                                      usedCondition: true)]
    
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
        availableItemsSection = activeItems
        headerItemsSection = headerAvalilableItemsSection
        
        
        myListingTableView.delegate = self
        myListingTableView.dataSource = self
        
        myListingTableView.register(MyListingTableViewCell.nib(),
                                    forCellReuseIdentifier: MyListingTableViewCell.identifier)

        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func activeItemsBtnPressed(_ sender: UIButton) {
        availableItemsSection = activeItems
        headerItemsSection = headerAvalilableItemsSection
        self.myListingTableView.reloadData()
    }
    
    
    @IBAction func soldItemsBtbPressed(_ sender: UIButton) {
        availableItemsSection = soldItems
        headerItemsSection = headreSoldItemsSection
        self.myListingTableView.reloadData()
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
            return headerItemsSection.count
        case 1:
            return availableItemsSection.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = myListingTableView.dequeueReusableCell(withIdentifier: MyListingTableViewCell.identifier, for: indexPath) as? MyListingTableViewCell else {return UITableViewCell()}
        
        switch indexPath.section {
        case 0:
            cell.setup(item: headerItemsSection[indexPath.row])
        case 1:
            cell.setup(item: availableItemsSection[indexPath.row])
        default:
            return UITableViewCell()
        }
        return cell
    }
}
