//
//  ForgotPasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Outlets
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var sentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        
       
        emailTextField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: Actions
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        showNextVC(name: "ForgotPasswordVerification", identifier: "ForgotPasswordVerificationViewController")
    }
    
    //MARK: - Navigation method
    
    // Show next VC
    func showNextVC(name: String, identifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: name, bundle: nil)
        let createAccountVC = storyBoard.instantiateViewController(withIdentifier: identifier)
        createAccountVC.modalPresentationStyle = .fullScreen
        self.show(createAccountVC, sender: self)
    }
    
    //MARK: - Validation methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let email = emailTextField.text else {return}
        
        let isValidateEmail = validateEmailId(with: email)
        if isValidateEmail == false {
            sentButton.isEnabled = false
        } else {
            sentButton.isEnabled = true
        }
        reloadInputViews()
    }
    
    func validateEmailId(with emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        print("isValidateEmail:\(isValidateEmail)")
        return isValidateEmail
    }
}
