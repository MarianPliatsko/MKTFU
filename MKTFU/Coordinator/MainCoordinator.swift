//
//  MainCoordinator.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCooerdinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    
    func start() {
        let vc = LogInViewController.instantiate(name: "Main")
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreateAccountVC() {
        let vc = CreateAccountViewController.instantiate(name: "CreateAccount")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreatePasswordVC() {
        let vc = CreatePasswordViewController.instantiate(name: "CreatePassword")
        vc.user = CreateAccountViewController.user
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSuccessVC() {
        let vc = SuccessViewController.instantiate(name: "Success")
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    
    func goToForgotPasswordVC() {
        let vc = ForgotPasswordViewController.instantiate(name: "ForgotPassword")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToForgotPasswordCompleteVC() {
        let vc = ForgotPasswordCompleteViewController.instantiate(name: "ForgotPasswordComplete")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToHomeVC() {
        let vc = HomeViewController.instantiate(name: "Home")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreateOfferVC() {
        let vc = CreateOfferViewController.instantiate(name: "CreateOffer")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToProductDetailVC() {
        let vc = ProductDetailViewController.instantiate(name: "ProductDetail")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToTermsOfServiceVC() {
        let vc = TermsOfServiceViewController.instantiate(name: "TermsOfService")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToPrivacyPolicyVC() {
        let vc = PrivacyPolicyViewController.instantiate(name: "PrivacyPolicy")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCheckoutViewController() {
        let vc = CheckoutViewController.instantiate(name: "Checkout")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToPickupInformationViewController() {
        let vc = PickupInformationViewController.instantiate(name: "PickupInformation")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMenuViewController() {
        let vc = MenuViewController.instantiate(name: "Menu")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToAccountInformationViewController() {
        let vc = AccountInformationViewController.instantiate(name: "AccountInformation")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToChangePasswordViewController() {
        let vc = ChangePasswordViewController.instantiate(name: "ChangePassword")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMyPurchasesViewController() {
        let vc = MyPurchasesViewController.instantiate(name: "MyPurchases")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMyListingsViewController() {
        let vc = MyListingsViewController.instantiate(name: "MyListing")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFAQViewController() {
        let vc = FAQViewController.instantiate(name: "FAQ")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToHowMKTFYWorksViewController() {
        let vc = HowMKTFYWorksViewController.instantiate(name: "HowMKTFYWorks")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToContactUsViewController() {
        let vc = ContactUsViewController.instantiate(name: "ContactUs")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
}