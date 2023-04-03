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
    let checkedImage = UIImage(named: "CheckedImage")
    let uncheckedImage = UIImage(named: "UncheckedImage")
    var isChecked: Bool = false
    let termsAndPolicyText = "By checking this box, you agree to our Terms of Service and our Privacy Policy"
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var lpViewPassword: LpCustomView!
    @IBOutlet weak var lpViewConfirmPassword: LpCustomView!
    
    @IBOutlet weak var sixCharactersImage: UIImageView!
    @IBOutlet weak var oneUppercaseImage: UIImageView!
    @IBOutlet weak var oneNumberImage: UIImageView!
    
    @IBOutlet weak var checkMarkTermsAndPolicyButton: UIButton!
    @IBOutlet weak var termsAndPolicyTextView: UITextView!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var agreementTextView: UITextView! {
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
    
    @IBAction func checkMarkButtonPressed(_ sender: UIButton) {
        checkMarkTapped()
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        createAccount(user: user)
        coordinator?.goToSuccessVC()
    }


    func createAccount(user: User) {
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
                print(user)
                if user != nil {
                    self.getAccessToken(email: user!, password: password)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getAccessToken(email: String, password: String) {
        Auth0Manager.shared.loginWithEmail(email: email, password: password) { result in
            switch result {
            case .success(let accessToken):
                print(accessToken)
                if accessToken != nil {
                    self.getUserID(accessString: accessToken!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserID(accessString: String) {
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
    
    func createUserOnBackend (userID: String, token: String){
        
        let userData = ["id": userID,
                        "firstName": user.firstName,
                        "lastName": user.lastName,
                        "email": user.email,
                        "phone": user.phone,
                        "address": user.address,
                        "city": user.city
        ]
        
        NetworkManager.shared.request(endpoint: "api/User/register",
                                      type: User.self,
                                      token: token,
                                      httpMethod: .post,
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
    
    func validating() {
        
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
    
    //MARK: - Change UI methods
    
    //Change image of check mark
    func checkMarkTapped() {
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







