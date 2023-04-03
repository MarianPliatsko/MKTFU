//
//  AccountInformationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-12.
//

import UIKit

class AccountInformationViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var user = User()
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var lpFirstNameView: LpCustomView!
    @IBOutlet weak var lpLastNameView: LpCustomView!
    @IBOutlet weak var lpEmailView: LpCustomView!
    @IBOutlet weak var lpPhoneView: LpCustomView!
    @IBOutlet weak var lpPickupAddressView: LpCustomView!
    @IBOutlet weak var lpCityView: LpCustomView!
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        setupUI(user: user)
        
    }
    
    //MARK: - IBAction
    
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
       
    }
    
    //MARK: - Methods
    
    func setupUI(user: User) {
        lpFirstNameView.txtInputField.text = user.firstName
        lpLastNameView.txtInputField.text = user.lastName
        lpEmailView.txtInputField.text = user.email
        lpPhoneView.txtInputField.text = user.phone
        lpPickupAddressView.txtInputField.text = user.address
        lpCityView.txtInputField.text = user.city
    }

}
