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
    private var alert = CustomAlertView()
    private let validation = Validate()
    private let keyChain = KeychainSwift()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var oldPasswordView: LpCustomView!
    @IBOutlet private weak var newPasswordView: LpCustomView!
    @IBOutlet private weak var confirmNewPasswordView: LpCustomView!
    @IBOutlet private weak var numberOfCharactersImageView: UIImageView!
    @IBOutlet private weak var oneUppercaseImageView: UIImageView!
    @IBOutlet private weak var oneNumberImageView: UIImageView!
    @IBOutlet private weak var updatePasswordButton: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        newPasswordView.txtInputField.addTarget(
            self,
            action: #selector(ChangePasswordViewController.textFieldDidChange(_:)),
            for: .editingChanged
        )
        confirmNewPasswordView.txtInputField.addTarget(
            self,
            action: #selector(ChangePasswordViewController.textFieldDidChange(_:)),
            for: .editingChanged
        )
        
        newPasswordView.lblPasswordSecurityLevel.isHidden = true
    }
    
    //MARK: - IBAction
    
    @IBAction private func updatePasswordBtnPressed(_ sender: UIButton) {
        updatePassword()
    }
    
    //MARK: - Methods
    
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
        NetworkManager.shared.request(endpoint: EndpointConstants.changePassword,
                                      type: Empty.self,
                                      token: keyChain.get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .post,
                                      resultsLimit: nil,
                                      parameters: parameters) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.coordinator?.goToSuccessVC()
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self?.alert.showAlert(view: self?.view ?? UIView(),
                                          alertText: AlertMessageConstants.wrongPassword,
                                          leftButtonText: "Cancel",
                                          rightButtonText: "Try again",
                                          onRightButton: {
                        self?.alert.hideAlert()
                    },
                                          onLeftButton: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validatePassword(with: validation.validate(
            password: newPasswordView.txtInputField.text ?? ""))
    }
    
    private func validatePassword(with validationResult: PasswordValidationResult) {
        let validPasswordImageCheckmark = UIImage(named: "Icon awesome-check-circle-fill")
        let oldPasswordFromKeyChain = keyChain.get(KeychainConstants.password)
        switch validationResult {
        case .valid:
            numberOfCharactersImageView.image = validPasswordImageCheckmark
            oneUppercaseImageView.image = validPasswordImageCheckmark
            oneNumberImageView.image = validPasswordImageCheckmark
            
            if newPasswordView.txtInputField.text == confirmNewPasswordView.txtInputField.text && oldPasswordView.txtInputField.text == oldPasswordFromKeyChain {
                updatePasswordButtonIsActive()
            } else {
                updatePasswordButtoniSNotActive()
            }
        case .invalid(let passedValidationChecks):
            if passedValidationChecks.contains(.enoughCharacters) {
                numberOfCharactersImageView.image = validPasswordImageCheckmark
            }
            if passedValidationChecks.contains(.hasOneDigit) {
                oneNumberImageView.image = validPasswordImageCheckmark
            }
            if passedValidationChecks.contains(.hasOneUppercase) {
                oneUppercaseImageView.image = validPasswordImageCheckmark
            }
            updatePasswordButtoniSNotActive()
        }
    }
    
    private func updatePasswordButtonIsActive() {
        updatePasswordButton.isEnabled = true
        updatePasswordButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
    }
    private func updatePasswordButtoniSNotActive() {
        updatePasswordButton.isEnabled = false
        updatePasswordButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
    }
}
