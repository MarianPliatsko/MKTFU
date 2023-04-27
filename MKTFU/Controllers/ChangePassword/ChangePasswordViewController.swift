//
//  ChangePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import Auth0
import KeychainSwift

class ChangePasswordViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var user = User()
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
    @IBOutlet private weak var oneSpecialCharacterImageView: UIImageView!
    @IBOutlet private weak var updatePasswordButton: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        setupTextFields()
        
        newPasswordView.lblPasswordSecurityLevel.isHidden = true
    }
    
    //MARK: - IBAction
    
    @IBAction func updatePasswordButtonPressed(_ sender: UIButton) {
        updatePassword()
    }
    
    //MARK: - Methods
    
    private func setupTextFields() {
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
    }
    
    private func updatePassword() {
        let oldPasswordFromKeyChain = keyChain.get(KeychainConstants.passwordKey)
        let oldPassword = oldPasswordView.txtInputField.text
        let newPassword = newPasswordView.txtInputField.text
        let confirnNewPassword = confirmNewPasswordView.txtInputField.text
        let validNewPassword = newPassword?.validate(regEX: ValidationConstants.password)
        let validConfirmNewPassword = confirnNewPassword?.validate(regEX: ValidationConstants.password)
        guard oldPassword == oldPasswordFromKeyChain else {return}
        if validNewPassword == true, validConfirmNewPassword == true, newPassword == confirnNewPassword {
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
                    self?.coordinator?.goToSuccessVC(user: self?.user ?? User())
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
    
    @objc private func textFieldDidChange(_ textField: UITextField) {        validatePassword(with: validation.validatePassword(
            password: newPasswordView.txtInputField.text ?? ""))
    }
    
    private func validatePassword(with validationResult: PasswordValidationResult) {
        let validPasswordImageCheckmark = UIImage(named: ImageNameConstrants.validePasswordCheckmark)
        let invalidPasswordImageCheckmark = UIImage(
            named: ImageNameConstrants.invalidPasswordCheckmark)
        let newPassword = newPasswordView.txtInputField.text
        let confirmPassword = confirmNewPasswordView.txtInputField.text
        let oldPassword = oldPasswordView.txtInputField.text
        let oldPasswordFromKeyChain = keyChain.get(KeychainConstants.passwordKey)
        switch validationResult {
        case .valid:
            numberOfCharactersImageView.image = validPasswordImageCheckmark
            oneUppercaseImageView.image = validPasswordImageCheckmark
            oneNumberImageView.image = validPasswordImageCheckmark
            oneSpecialCharacterImageView.image = validPasswordImageCheckmark
            passwordIsStrongShow()
            
            if newPassword == confirmPassword, oldPassword == oldPasswordFromKeyChain {
                updatePasswordButtonIsActive()
            } else {
                updatePasswordButtoniSNotActive()
            }
        case .invalid(let passedValidationChecks):
            if passedValidationChecks.contains(.enoughCharacters) {
                numberOfCharactersImageView.image = validPasswordImageCheckmark
                passwordIsWeakShow()
            } else {
                hidePasswordSecurityLevelLabel()
                numberOfCharactersImageView.image = invalidPasswordImageCheckmark
            }
            if passedValidationChecks.contains(.hasOneDigit) {
                oneNumberImageView.image = validPasswordImageCheckmark
            } else {
                oneNumberImageView.image = invalidPasswordImageCheckmark
            }
            if passedValidationChecks.contains(.hasOneUppercase) {
                oneUppercaseImageView.image = validPasswordImageCheckmark
            } else {
                oneUppercaseImageView.image = invalidPasswordImageCheckmark
            }
            if passedValidationChecks.contains(.hasOneSymbol) {
                oneSpecialCharacterImageView.image = validPasswordImageCheckmark
            } else {
                oneSpecialCharacterImageView.image = invalidPasswordImageCheckmark
            }
            updatePasswordButtoniSNotActive()
        }
    }
    
    private func hidePasswordSecurityLevelLabel() {
        newPasswordView.showSecurityLevel = false
    }
    
    private func passwordIsWeakShow() {
        newPasswordView.showSecurityLevel = true
        newPasswordView.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.WarningYellow)
        newPasswordView.lblPasswordSecurityLevel.text = "Weak"
    }
    
    private func passwordIsStrongShow() {
        newPasswordView.showSecurityLevel = true
        newPasswordView.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.GoodJobGreen)
        newPasswordView.lblPasswordSecurityLevel.text = "Strong"
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
