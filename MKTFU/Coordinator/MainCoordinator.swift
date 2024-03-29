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
    
    func goToCreatePasswordVC(user: User) {
        let vc = CreatePasswordViewController.instantiate(name: "CreatePassword")
        vc.user = user
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToSuccessVC(user: User) {
        let vc = SuccessViewController.instantiate(name: "Success")
        vc.coordinator = self
        vc.user = user
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
    
    func goToHomeVC(user: User?) {
        let vc = HomeViewController.instantiate(name: "Home")
        vc.coordinator = self
        if user != nil {
            vc.user = user!
        }
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToCreateOfferVC(user: User, product: Product?, with mode: CreateOfferMode) {
        let vc = CreateOfferViewController.instantiate(name: "CreateOffer")
        vc.coordinator = self
        if let product = product {
            vc.product = product
        }
        vc.setupMode(mode: mode)
        vc.user = user
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToProductDetailVC(user: User, with products: Product) {
        let vc = ProductDetailViewController.instantiate(name: "ProductDetail")
        vc.coordinator = self
        vc.product = products
        vc.user = user
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
    
    func goToCheckoutViewController(user: User, with product: Product) {
        let vc = CheckoutViewController.instantiate(name: "Checkout")
        vc.coordinator = self
        vc.product = product
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToPickupInformationViewController(user: User, with product: Product, with mode: PickupInformationMode) {
        let vc = PickupInformationViewController.instantiate(name: "PickupInformation")
        vc.coordinator = self
        vc.product = product
        vc.setupMode(mode: mode)
        vc.user = user
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMenuViewController(user: User) {
        let vc = MenuViewController.instantiate(name: "Menu")
        vc.coordinator = self
        vc.user = user
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToAccountInformationViewController() {
        let vc = AccountInformationViewController.instantiate(name: "AccountInformation")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToChangePasswordViewController(user: User) {
        let vc = ChangePasswordViewController.instantiate(name: "ChangePassword")
        vc.coordinator = self
        vc.user = user
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMyPurchasesViewController(user: User) {
        let vc = MyPurchasesViewController.instantiate(name: "MyPurchases")
        vc.coordinator = self
        vc.user = user
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToMyListingsViewController(user: User) {
        let vc = MyListingsViewController.instantiate(name: "MyListing")
        vc.coordinator = self
        vc.user = user
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToFAQViewController() {
        let vc = FAQViewController.instantiate(name: "FAQ")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToHowMKTFYWorksViewController(faq: FAQ) {
        let vc = HowMKTFYWorksViewController.instantiate(name: "HowMKTFYWorks")
        vc.coordinator = self
        vc.setup(faq: faq)
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToContactUsViewController() {
        let vc = ContactUsViewController.instantiate(name: "ContactUs")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToNotificationsViewController() {
        let vc = NotificationsViewController.instantiate(name: "Notifications")
        vc.coordinator = self
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(vc, animated: true)
    }
}
