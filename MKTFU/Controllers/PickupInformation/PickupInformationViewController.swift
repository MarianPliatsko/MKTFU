//
//  PickupInformationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-10.
//

import UIKit

class PickupInformationViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var dataSource = ItemsDataTest()
    
    //MARK: - Outlets
    
    @IBOutlet weak var productImageView: UIImageView! {
        didSet {
            productImageView.layer.cornerRadius = productImageView.layer.bounds.width / 2
            productImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var productNameLabel: UILabel!
    
    
    //MARK: View Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        setupUI(data: dataSource)
    }
    
    //MARK: - IBAction
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        coordinator?.goToSuccessVC()
    }
    
    //MARK: - Methods
    
    func setupUI(data: ItemsDataTest) {
        productNameLabel.text = data.name
    }

}
