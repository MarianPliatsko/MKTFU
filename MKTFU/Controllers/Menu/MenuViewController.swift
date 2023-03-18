//
//  MenuViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-10.
//

import UIKit

class MenuViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: - IBAction
    
    @IBAction func closeMenuBtnPressed(_ sender: UIButton) {
        coordinator?.goToHomeVC()
    }
    
    @IBAction func accountInformationBtnPressed(_ sender: UIButton) {
        coordinator?.goToAccountInformationViewController()
    }
    
    @IBAction func changePasswordBtnPressed(_ sender: UIButton) {
        coordinator?.goToChangePasswordViewController()
    }
    
    @IBAction func myPurchasesBtnPressed(_ sender: UIButton) {
        coordinator?.goToMyPurchasesViewController()
    }
    
    @IBAction func myListingBtnPressed(_ sender: UIButton) {
        coordinator?.goToMyListingsViewController()
    }
    
    @IBAction func faqBtnPressed(_ sender: UIButton) {
        coordinator?.goToFAQViewController()
    }
    
    @IBAction func contactUsBtnPressed(_ sender: UIButton) {
        coordinator?.goToContactUsViewController()
    }
    
    @IBAction func logOut(_sendeer: UIButton) {
        Auth0Manager.shared.logOut()
        coordinator?.start()
    }
    
}
