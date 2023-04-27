//
//  MenuViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-10.
//

import UIKit
import KeychainSwift

class MenuViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var user = User()
    private var notificationAndListingCount: NotificationCount?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var userFullNameLabel: UILabel!
    @IBOutlet private weak var myNotificationMessageCountView: UIView!
    @IBOutlet private weak var myListingCountView: UIView!
    @IBOutlet private weak var myNotificationMessageCountLabel: UILabel!
    @IBOutlet private weak var myListingCountLabel: UILabel!
    
    //MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideMyListingCountView()
        hideNotificationsCountView()
        getNotificationAndListingCount()
    }
    
    //MARK: - IBAction
    
    @IBAction private func closeMenuBtnPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func accountInformationBtnPressed(_ sender: UIButton) {
        coordinator?.goToAccountInformationViewController()
    }
    
    @IBAction private func changePasswordBtnPressed(_ sender: UIButton) {
        coordinator?.goToChangePasswordViewController(user: user)
    }
    
    @IBAction private func myPurchasesBtnPressed(_ sender: UIButton) {
        coordinator?.goToMyPurchasesViewController(user: user)
    }
    
    @IBAction private func myListingBtnPressed(_ sender: UIButton) {
        coordinator?.goToMyListingsViewController(user: user)
    }
    
    @IBAction private func notificationBtnPressed(_ sender: UIButton) {
        coordinator?.goToNotificationsViewController()
    }
    
    @IBAction private func faqBtnPressed(_ sender: UIButton) {
        coordinator?.goToFAQViewController()
    }
    
    @IBAction private func contactUsBtnPressed(_ sender: UIButton) {
        coordinator?.goToContactUsViewController()
    }
    
    @IBAction private func logOut(_sendeer: UIButton) {
        Auth0Manager.shared.logOut()
        coordinator?.start()
    }
    
    //MARK: - Methods
    
    private func hideMyListingCountView() {
        myListingCountView.isHidden = true
    }
    
    private func hideNotificationsCountView() {
        myNotificationMessageCountView.isHidden = true
    }
    
    private func showMyListingCountView() {
        myListingCountView.isHidden = false
    }
    
    private func showNotificationCountView() {
        myNotificationMessageCountView.isHidden = false
    }
    
    private func setupUI() {
        userFullNameLabel.text = "\(user.firstName) \(user.lastName)"
        if notificationAndListingCount?.pendingListings != 0 {
            showMyListingCountView()
            myListingCountLabel.text = "\(notificationAndListingCount?.pendingListings ?? 0)"
        } else {
            hideMyListingCountView()
        }
        if notificationAndListingCount?.unreadNotifications != 0 {
            showNotificationCountView()
            myNotificationMessageCountLabel.text = "\(notificationAndListingCount?.unreadNotifications ?? 0)"
        } else {
            hideNotificationsCountView()
        }
    }
    
    private func getNotificationAndListingCount() {
        NetworkManager.shared.request(endpoint: EndpointConstants.notificationCount,
                                      type: NotificationCount.self,
                                      token: KeychainSwift().get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let count):
                DispatchQueue.main.async {
                    self?.notificationAndListingCount = count
                    self?.setupUI()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
