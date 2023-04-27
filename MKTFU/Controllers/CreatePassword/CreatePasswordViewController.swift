//
//  CreatePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-02.
//

import UIKit
import Auth0

class CreatePasswordViewController: UIViewController {
    
    //MARK: - Properties
    weak var coordinator: MainCoordinator?
    var user = User()
    private var isChecked: Bool = false
    private let validation = Validate()
    private let alert = CustomAlertView()
    private let createUserService = CreateUserService()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var lpViewPassword: LpCustomView!
    @IBOutlet private weak var lpViewConfirmPassword: LpCustomView!
    @IBOutlet private weak var numberOfCharactersImageView: UIImageView!
    @IBOutlet private weak var oneUppercaseImageView: UIImageView!
    @IBOutlet private weak var oneNumberImageView: UIImageView!
    @IBOutlet private weak var oneSpecialCharacterImageView: UIImageView!
    @IBOutlet private weak var checkMarkTermsAndPolicyButton: UIButton!
    @IBOutlet private weak var termsAndPolicyTextView: UITextView!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var agreementTextView: UITextView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTextView()
        setupTextViewUI()
        setupTextField()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTextViewUI()
    }
    
    //MARK: - Actions
    
    @IBAction private func checkMarkButtonPressed(_ sender: UIButton) {
        checkMarkTapped()
    }
    
    @IBAction private func createAccountButtonPressed(_ sender: UIButton) {
        createAccount()
    }
    
    //MARK: - Methods
    
    private func setupTextField() {
        lpViewPassword.txtInputField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewConfirmPassword.txtInputField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupUI() {
        createAccountButton.isEnabled = false
        checkMarkTermsAndPolicyButton.setImage(UIImage(named: ImageNameConstrants.uncheckedImage),
                                               for: UIControl.State.normal)
        lpViewPassword.lblPasswordSecurityLevel.isHidden = true
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTextViewUI () {
        agreementTextView.centerVertically()
    }
    
    private func setupTextView() {
        termsAndPolicyTextView.delegate = self
        termsAndPolicyTextView.addHyperLinksToText(text: OtherTextConstants.termsAndPolicyText,
                                                   textView: termsAndPolicyTextView)
    }
    
    private func createAccount() {
        guard let password = lpViewPassword.txtInputField.text else {return}
        
        createUserService.createUser(user: user,
                                     password: password) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.coordinator?.goToSuccessVC()
                }
            case .failure(let error):
                self?.handleLoginError(error: error)
            }
        }
    }
    
    private func handleLoginError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.showAlert(message: error.localizedDescription, tryAgain: {
                self?.createAccount()
            })
        }
    }
    
    private func showAlert(message: String, tryAgain: @escaping() ->()) {
        alert.showAlert(view: self.view,
                        alertText: message,
                        leftButtonText: "Cancel",
                        rightButtonText: "Try again") {
            tryAgain()
        } onLeftButton: { [weak self] in
            self?.alert.hideAlert()
        }
    }
    
    // MARK: - Validation methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        validatePassword(with: validation.validatePassword(
            password: lpViewPassword.txtInputField.text ?? ""))
    }
    
    private func validatePassword(with validationResult: PasswordValidationResult) {
        let validPasswordImageCheckmark = UIImage(
            named: ImageNameConstrants.validePasswordCheckmark)
        let invalidPasswordImageCheckmar = UIImage(
            named: ImageNameConstrants.invalidPasswordCheckmark)
        let password = lpViewPassword.txtInputField.text
        let confirmPassword = lpViewConfirmPassword.txtInputField.text
        switch validationResult {
        case .valid:
            numberOfCharactersImageView.image = validPasswordImageCheckmark
            oneUppercaseImageView.image = validPasswordImageCheckmark
            oneNumberImageView.image = validPasswordImageCheckmark
            oneSpecialCharacterImageView.image = validPasswordImageCheckmark
            passwordIsStrongShow()
            
            if password == confirmPassword && isChecked {
                createPasswordButtonIsActive()
            } else {
                createPasswordButtoniSNotActive()
            }
        case .invalid(let passedValidationChecks):
            if passedValidationChecks.contains(.enoughCharacters) {
                numberOfCharactersImageView.image = validPasswordImageCheckmark
                passwordIsWeakShow()
            } else {
                hidePasswordSecurityLevelLabel()
                numberOfCharactersImageView.image = invalidPasswordImageCheckmar
            }
            if passedValidationChecks.contains(.hasOneDigit) {
                oneNumberImageView.image = validPasswordImageCheckmark
            } else {
                oneNumberImageView.image = invalidPasswordImageCheckmar
            }
            if passedValidationChecks.contains(.hasOneUppercase) {
                oneUppercaseImageView.image = validPasswordImageCheckmark
            } else {
                oneUppercaseImageView.image = invalidPasswordImageCheckmar
            }
            if passedValidationChecks.contains(.hasOneSymbol) {
                oneSpecialCharacterImageView.image = validPasswordImageCheckmark
            } else {
                oneSpecialCharacterImageView.image = invalidPasswordImageCheckmar
            }
            createPasswordButtoniSNotActive()
        }
    }
    
    private func passwordIsWeakShow() {
        lpViewPassword.showSecurityLevel = true
        lpViewPassword.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.WarningYellow)
        lpViewPassword.lblPasswordSecurityLevel.text = "Weak"
    }
    
    private func passwordIsStrongShow() {
        lpViewPassword.showSecurityLevel = true
        lpViewPassword.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.GoodJobGreen)
        lpViewPassword.lblPasswordSecurityLevel.text = "Strong"
    }
    
    private func hidePasswordSecurityLevelLabel() {
        lpViewPassword.showSecurityLevel = false
    }
    
    private func createPasswordButtonIsActive() {
        createAccountButton.isEnabled = true
        createAccountButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
    }
    private func createPasswordButtoniSNotActive() {
        createAccountButton.isEnabled = false
        createAccountButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
    }
    
    private func checkMarkTapped(){
        isChecked.toggle()
        switch isChecked {
        case true :
            checkMarkTermsAndPolicyButton.setImage(
                UIImage(named: ImageNameConstrants.checkedImage),
                for: UIControl.State.normal)
            validatePassword(with: validation.validatePassword(
                password: lpViewPassword.txtInputField.text ?? ""))
        case false :
            checkMarkTermsAndPolicyButton.setImage(
                UIImage(named: ImageNameConstrants.uncheckedImage),
                for: UIControl.State.normal)
            createPasswordButtoniSNotActive()
        }
    }
}

//MARK: - extension CreatePasswordViewController: UITextViewDelegate

extension CreatePasswordViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.scheme == "terms" {
            coordinator?.goToTermsOfServiceVC()
            return false
        } else if URL.scheme == "privacy"{
            coordinator?.goToPrivacyPolicyVC()
            return false
        }
        return true
    }
}







