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
    let validate = Validate()
    private let checkedImage = UIImage(named: "CheckedImage")
    private let uncheckedImage = UIImage(named: "UncheckedImage")
    private var isChecked: Bool = false
    private let termsAndPolicyText = "By checking this box, you agree to our Terms of Service and our Privacy Policy"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var lpViewPassword: LpCustomView!
    @IBOutlet private weak var lpViewConfirmPassword: LpCustomView!
    @IBOutlet private weak var sixCharactersImage: UIImageView!
    @IBOutlet private weak var oneUppercaseImage: UIImageView!
    @IBOutlet private weak var oneNumberImage: UIImageView!
    @IBOutlet private weak var checkMarkTermsAndPolicyButton: UIButton!
    @IBOutlet private weak var termsAndPolicyTextView: UITextView!
    @IBOutlet private weak var createAccountButton: UIButton!
    @IBOutlet private weak var agreementTextView: UITextView! {
        didSet {
            agreementTextView.centerVertically()
        }
    }
    
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
        validating()
    }
    
    private func validating() {
        
        guard let password = lpViewPassword.txtInputField.text,
              let confirmPassword = lpViewConfirmPassword.txtInputField.text else {return}
        
        let validPassword = validate.validatePassword.validatePassword(password: password)
        if validPassword == false {
        }
        
        let sixCharacters = validate.validateString.validateString(regEX: "^.{6,}$",
                                                                   password: password)
        if sixCharacters == false {
            sixCharactersImage.image = UIImage(named: "Icon awesome-check-circle")
            lpViewPassword.lblPasswordSecurityLevel.isHidden = true
            reloadInputViews()
        } else {
            sixCharactersImage.image = UIImage(named: "Icon awesome-check-circle-fill")
            lpViewPassword.lblPasswordSecurityLevel.isHidden = false
            lpViewPassword.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.WarningYellow)
            lpViewPassword.lblPasswordSecurityLevel.text = "Weak"
            reloadInputViews()
        }
        
        let oneUppercase = validate.validateString.validateString(regEX: ".*[A-Z]+.*",
                                                                  password: password)
        if oneUppercase == false {
            oneUppercaseImage.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneUppercaseImage.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        let oneNumber = validate.validateString.validateString(regEX: ".*[0-9]+.*",
                                                               password: password)
        if oneNumber == false {
            oneNumberImage.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneNumberImage.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        if sixCharacters == true, oneUppercase == true, oneNumber == true {
            lpViewPassword.lblPasswordSecurityLevel.isHidden = false
            lpViewPassword.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.GoodJobGreen)
            lpViewPassword.lblPasswordSecurityLevel.text = "Strong"
            reloadInputViews()
        }
        
        if validPassword == true, password == confirmPassword, sixCharacters == true, oneUppercase == true, oneNumber == true, isChecked == true {
            createAccountButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
            createAccountButton.isEnabled = true
            reloadInputViews()
        } else {
            createAccountButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
            createAccountButton.isEnabled = false
            reloadInputViews()
        }
        reloadInputViews()
    }
    
    private func checkMarkTapped() {
        isChecked.toggle()
        
        if isChecked == true {
            checkMarkTermsAndPolicyButton.setImage(checkedImage, for: UIControl.State.normal)
            validating()
        } else {
            checkMarkTermsAndPolicyButton.setImage(uncheckedImage, for: UIControl.State.normal)
            validating()
        }
    }
}

extension CreatePasswordViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.scheme == "terms" {
            coordinator?.goToTermsOfServiceVC()
            return false
        } else  if URL.scheme == "privacy"{
            coordinator?.goToPrivacyPolicyVC()
            return false
        }
        return true
        // let the system open this URL
    }
    
}







