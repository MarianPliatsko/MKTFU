//
//  ChangePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import Auth0
import KeychainSwift

class ChangePasswordViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var passwordAlert = ChangePasswordAlertView()
    private let validation = Validate()
    private let keyChain = KeychainSwift()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var oldPasswordView: LpCustomView!
    @IBOutlet private weak var newPasswordView: LpCustomView!
    @IBOutlet private weak var confirmNewPasswordView: LpCustomView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        newPasswordView.lblPasswordSecurityLevel.isHidden = true
    }
    
    //MARK: - IBAction
    
    @IBAction private func updatePasswordBtnPressed(_ sender: UIButton) {
        updatePassword()
    }
    
    //MARK: - Methods
    
    private func setupPasswordAlertUI() {
        passwordAlert.view.translatesAutoresizingMaskIntoConstraints = false
        passwordAlert.view.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        passwordAlert.view.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        passwordAlert.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        passwordAlert.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        passwordAlert.view.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordAlert.view.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        passwordAlert.view.backgroundColor = UIColor.appColor(LPColor.TextGray40)
    }
    
    private func updatePassword() {
        let oldPasswordFromKeyChain = keyChain.get(KeychainConstants.password)
        let oldPassword = oldPasswordView.txtInputField.text
        let newPassword = newPasswordView.txtInputField.text
        let confirnNewPassword = confirmNewPasswordView.txtInputField.text
        let validNewPassword = validation.validatePassword.validatePassword(password: newPassword ?? "")
        let validConfirmNewPassword = validation.validatePassword.validatePassword(
            password: confirnNewPassword ?? "")
        guard oldPassword == oldPasswordFromKeyChain else {return}
        if validNewPassword, validConfirmNewPassword, newPassword == confirnNewPassword {
            changePasswordRequest(newPassword: newPassword ?? "",
                                  confirmedNewPassword: confirnNewPassword ?? "")
        }
    }
    
    private func changePasswordRequest(newPassword: String, confirmedNewPassword: String) {
        let parameters = ["newPassword": newPassword,
                          "confirmPassword": confirmedNewPassword]
        NetworkManager.shared.changePasswordRequest(endPoint: EndpointConstants.changePassword,
                                                    token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                                    parameters: parameters) { [weak self] result in
            switch result {
            case .success(let response):
                print(response)
            case .failure(_):
                self?.view.addSubview(self?.passwordAlert ?? UIView())
                self?.setupPasswordAlertUI()
            }
        }
    }
}
