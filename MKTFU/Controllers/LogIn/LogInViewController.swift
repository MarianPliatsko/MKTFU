//
//  ViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-30.
//

import UIKit

class LogInViewController: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var iForgotMyPasswordButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailIsIncorrectWarning: UILabel!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailIsIncorrectWarning.isHidden = true
        
        adjustForgotPusswordButton()
        
        emailTextField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        checkEmail()
    }
    
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        showCreateAccountVC()
    }
    
    
    //MARK: - Validation Methods
    
    // Check email validation while typing in text field
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let email = textField.text, email != "" {
            if self.isValidEmail(email) == false {
                self.logInButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
            } else {
                self.emailIsIncorrectWarning.isHidden = true
                self.logInButton.backgroundColor = UIColor.appColor(LPColor.WarningYellow)
            }
        }
        reloadInputViews()
    }
    
    // Check email validation after button pressed
    func checkEmail() {
        if let email = emailTextField.text, email != "" {
            if self.isValidEmail(email) == false {
                self.emailIsIncorrectWarning.isHidden = false
            } else {
                self.emailIsIncorrectWarning.isHidden = true
            }
        }
        reloadInputViews()
    }
    
    // Check email for validation
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - UI setup methods
    
    // Make underline fot button text and adjust
    func adjustForgotPusswordButton() {
        let attributedTitle = NSAttributedString(
            string: "I forgot my password" ,
            attributes: [
                .foregroundColor: UIColor.appColor(LPColor.WarningYellow)!,
                .font: UIFont(name: "OpenSans", size: 14)!,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        iForgotMyPasswordButton.setAttributedTitle(attributedTitle, for: .normal)
    }
    
    //MARK: - Navigation methods
    
    // Show CreateAccount VC
    func showCreateAccountVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "CreateAccount", bundle: nil)
        let createAccountVC = storyBoard.instantiateViewController(withIdentifier: "AccountViewController")
        createAccountVC.modalPresentationStyle = .fullScreen
        self.show(createAccountVC, sender: self)
    }
}
