//
//  CreatePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-02.
//

import UIKit
import Auth0

class CreatePasswordViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    weak var coordinator: MainCoordinator?
    var user = User()
    private var isChecked: Bool = false
    private let validation = Validate()
    private let checkedImage = UIImage(named: "CheckedImage")
    private let uncheckedImage = UIImage(named: "UncheckedImage")
    private let termsAndPolicyText = "By checking this box, you agree to our Terms of Service and our Privacy Policy"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var lpViewPassword: LpCustomView!
    @IBOutlet private weak var lpViewConfirmPassword: LpCustomView!
    @IBOutlet private weak var numberOfCharactersImageView: UIImageView!
    @IBOutlet private weak var oneUppercaseImageView: UIImageView!
    @IBOutlet private weak var oneNumberImageView: UIImageView!
    @IBOutlet private weak var checkMarkTermsAndPolicyButton: UIButton!
    @IBOutlet private weak var termsAndPolicyTextView: UITextView!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var agreementTextView: UITextView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //createAccountButton.isEnabled = false
        
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        //call text view delegate
        termsAndPolicyTextView.delegate = self
        
        //call clickable links in text view
        termsAndPolicyTextView.addHyperLinksToText(text: termsAndPolicyText, textView: termsAndPolicyTextView)
        
        // Set default image for check mark
        checkMarkTermsAndPolicyButton.setImage(uncheckedImage, for: UIControl.State.normal)
        
        lpViewPassword.txtInputField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewConfirmPassword.txtInputField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPassword.lblPasswordSecurityLevel.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        agreementTextView.centerVertically()
    }
    
    //MARK: - Actions
    
    @IBAction private func checkMarkButtonPressed(_ sender: UIButton) {
        checkMarkTapped()
    }
    
    @IBAction private func createAccountButtonPressed(_ sender: UIButton) {
        createAccount(user: user)
        coordinator?.goToSuccessVC()
    }
    
    //MARK: - Methods
    
    private func setupUI () {
        agreementTextView.centerVertically()
    }
    
    private func createAccount(user: User) {
        let userMetaData = ["firstName": user.firstName,
                            "lastName": user.lastName,
                            "email": user.email,
                            "phone": user.phone,
                            "streetAddress": user.address,
                            "city": user.city]
        guard let password = lpViewPassword.txtInputField.text else {return}
        
        Auth0Manager.shared.createUser(email: user.email,
                                       password: password,
                                       connection: Auth0Constants.connection,
                                       userMetaData: userMetaData) { result in
            switch result {
            case .success(let user):
                if user != nil {
                    self.getAccessToken(email: user!, password: password)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getAccessToken(email: String, password: String) {
        Auth0Manager.shared.loginWithEmail(email: email, password: password) { result in
            switch result {
            case .success(let accessToken):
                if accessToken != nil {
                    self.getUserID(accessString: accessToken!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getUserID(accessString: String) {
        Auth0Manager.shared.getUserID(accessToken: accessString) { result in
            switch result {
            case .success(let userID):
                if userID != nil {
                    self.createUserOnBackend(userID: userID!, token: accessString)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createUserOnBackend (userID: String, token: String) {
        let userData = ["id": userID,
                        "firstName": user.firstName,
                        "lastName": user.lastName,
                        "email": user.email,
                        "phone": user.phone,
                        "address": user.address,
                        "city": user.city]
        
        NetworkManager.shared.request(endpoint: "api/User/register",
                                      type: User.self,
                                      token: token,
                                      httpMethod: .post,
                                      resultsLimit: nil,
                                      parameters: userData) { result in
            switch result {
            case .success(let user):
                print(user)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Validation methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validatePassword(with: validation.validate(
            password: lpViewPassword.txtInputField.text ?? ""))
    }
    
    private func validatePassword(with validationResult: PasswordValidationResult) {
        let validPasswordImageCheckmark = UIImage(named: "Icon awesome-check-circle-fill")
        switch validationResult {
        case .valid:
            numberOfCharactersImageView.image = validPasswordImageCheckmark
            oneUppercaseImageView.image = validPasswordImageCheckmark
            oneNumberImageView.image = validPasswordImageCheckmark
            
            if lpViewPassword.txtInputField.text == lpViewConfirmPassword.txtInputField.text && isChecked {
                createPasswordButtonIsActive()
            } else {
                createPasswordButtoniSNotActive()
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
            createPasswordButtoniSNotActive()
        }
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
            checkMarkTermsAndPolicyButton.setImage(checkedImage,
                                                   for: UIControl.State.normal)
            validatePassword(with: validation.validate(
                password: lpViewPassword.txtInputField.text ?? ""))
        case false :
            checkMarkTermsAndPolicyButton.setImage(uncheckedImage,
                                                   for: UIControl.State.normal)
            createPasswordButtoniSNotActive()
        }
    }
}

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







