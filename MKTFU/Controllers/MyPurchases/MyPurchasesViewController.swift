//
//  MyPurchasesViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit

class MyPurchasesViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(MyPurchasesTableViewCell.nib(),
                               forCellReuseIdentifier: MyPurchasesTableViewCell.identifier)
    }
}

extension MyPurchasesViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPurchasesTableViewCell.identifier, for: indexPath) as? MyPurchasesTableViewCell else {return UITableViewCell()}
        
        return cell
    }
}
