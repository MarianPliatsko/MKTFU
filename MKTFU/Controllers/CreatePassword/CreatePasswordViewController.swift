//
//  CreatePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-02.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    
    //MARK: - Properties
    
    let checkedImage = UIImage(named: "CheckedImage")
    let uncheckedImage = UIImage(named: "UncheckedImage")
    var isChecked: Bool = false
    let termsAndPolicyText = "By checking this box, you agree to our Terms of Service and our Privacy Policy"
    
    //MARK: - Outlets
    
    @IBOutlet weak var passwordSecurityLevelLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var sixCharactersImage: UIImageView!
    @IBOutlet weak var oneUppercaseImage: UIImageView!
    @IBOutlet weak var oneNumberImage: UIImageView!
    
    @IBOutlet weak var checkMarkTermsAndPolicyButton: UIButton!
    @IBOutlet weak var termsAndPolicyTextView: UITextView!
    
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        createAccountButton.isEnabled = false
        
        termsAndPolicyTextView.delegate = self
        termsAndPolicyTextView.addHyperLinksToText(text: termsAndPolicyText, textView: termsAndPolicyTextView)
        
        // Set default image for check mark
        checkMarkTermsAndPolicyButton.setImage(uncheckedImage, for: UIControl.State.normal)
        
        passwordTextField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        passwordSecurityLevelLabel.isHidden = true
        
    }
    
    //MARK: - Actions
    
    @IBAction func checkMarkButtonPressed(_ sender: UIButton) {
        checkMarkTapped()
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        showNextVC(name: "Success", identifier: "SuccessViewController")
    }
    
    
    //MARK: - Navigation methods
    
    // Show next VC
    func showNextVC(name: String, identifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let createAccountVC = storyBoard.instantiateViewController(withIdentifier: identifier)
        createAccountVC.modalPresentationStyle = .fullScreen
        self.show(createAccountVC, sender: self)
    }
    
    // MARK: - Validation methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        validate()
    }
        
    func validate() {
        
        guard let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {return}
        
        let validPassword = validatePassword(password: password)
        if validPassword == false {
        }
        
        let sixCharacters = validateString(regEX: "^.{6,}$", password: password)
        if sixCharacters == false {
            sixCharactersImage.image = UIImage(named: "Icon awesome-check-circle")
            passwordSecurityLevelLabel.isHidden = true
            reloadInputViews()
        } else {
            sixCharactersImage.image = UIImage(named: "Icon awesome-check-circle-fill")
            passwordSecurityLevelLabel.isHidden = false
            passwordSecurityLevelLabel.textColor = UIColor.appColor(LPColor.WarningYellow)
            passwordSecurityLevelLabel.text = "Weak"
            reloadInputViews()
        }
        
        let oneUppercase = validateString(regEX: ".*[A-Z]+.*", password: password)
        if oneUppercase == false {
            oneUppercaseImage.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneUppercaseImage.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        let oneNumber = validateString(regEX: ".*[0-9]+.*", password: password)
        if oneNumber == false {
            oneNumberImage.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneNumberImage.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        if sixCharacters == true, oneUppercase == true, oneNumber == true {
            passwordSecurityLevelLabel.isHidden = false
            passwordSecurityLevelLabel.textColor = UIColor.appColor(LPColor.GoodJobGreen)
            passwordSecurityLevelLabel.text = "Strong"
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
    
    // Validate
    func validateString(regEX: String, password: String) -> Bool {
        let passRegEx = regEX
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    // Validate password
    func validatePassword(password: String) -> Bool {
        //Minimum 6 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[A-Z]).{6,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    
    //MARK: - Change UI methods
    
    //Change image of check mark
    func checkMarkTapped() {
        isChecked.toggle()
        
        if isChecked == true {
            checkMarkTermsAndPolicyButton.setImage(checkedImage, for: UIControl.State.normal)
            validate()
        } else {
            checkMarkTermsAndPolicyButton.setImage(uncheckedImage, for: UIControl.State.normal)
            validate()
        }
    }
}

extension CreatePasswordViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
            if URL.scheme == "terms" {
                showNextVC(name: "TermsOfService", identifier: "TermsOfServiceViewController")
                return false
            } else  if URL.scheme == "privacy"{
               showNextVC(name: "PrivacyPolicy", identifier: "PrivacyPolicyViewController")
                 return false
            }
            return true
            // let the system open this URL
        }
    
}








