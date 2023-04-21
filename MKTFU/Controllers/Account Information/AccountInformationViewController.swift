//
//  AccountInformationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-12.
//

import UIKit
import KeychainSwift

class AccountInformationViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var user = User()
    private var keychain = KeychainSwift()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var lpFirstNameView: LpCustomView!
    @IBOutlet private weak var lpLastNameView: LpCustomView!
    @IBOutlet private weak var lpEmailView: LpCustomView!
    @IBOutlet private weak var lpPhoneView: LpCustomView!
    @IBOutlet private weak var lpPickupAddressView: LpCustomView!
    @IBOutlet private weak var lpCityView: LpCustomView!
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        getUserProfile()
    }
    
    //MARK: - IBAction

    @IBAction func saveBtnPressed(_ sender: UIButton) {
       updateUserProfile()
    }
    
    //MARK: - Methods
    
    func setupUI() {
        lpFirstNameView.txtInputField.text = user.firstName
        lpLastNameView.txtInputField.text = user.lastName
        lpEmailView.txtInputField.text = user.email
        lpPhoneView.txtInputField.text = user.phone
        lpPickupAddressView.txtInputField.text = user.address
        lpCityView.txtInputField.text = user.city
    }
    
    private func getUserProfile() {
        NetworkManager.shared.request(endpoint: "\(EndpointConstants.getUserProfile)\(KeychainSwift().get(KeychainConstants.userIDKey) ?? "")",
                                      type: User.self,
                                      token: keychain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.user = user
                    self?.setupUI()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func updateUserProfile() {
        
        let firstName = lpFirstNameView.txtInputField.text ?? ""
        let lastName = lpLastNameView.txtInputField.text ?? ""
        let email = lpEmailView.txtInputField.text ?? ""
        let phone = lpPhoneView.txtInputField.text ?? ""
        let address = lpPickupAddressView.txtInputField.text ?? ""
        let city = lpCityView.txtInputField.text ?? ""
        
        let parameters: [String: Any] = ["id": keychain.get(KeychainConstants.userIDKey) ?? "",
                                         "firstName": firstName,
                                         "lastName": lastName,
                                         "email": email,
                                         "phone": phone,
                                         "address": address,
                                         "city": city]
        
        NetworkManager.shared.request(endpoint: EndpointConstants.updateUserProfile,
                                      type: User.self,
                                      token: keychain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .put,
                                      resultsLimit: nil,
                                      parameters: parameters) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async { [self] in
                    self?.user = user
                    self?.coordinator?.goToSuccessVC()
                }
            case .failure(let error):
                print(error)
            }
        }
    }

}
