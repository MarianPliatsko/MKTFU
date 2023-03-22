//
//  ViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-30.
//

import UIKit
import Auth0
import JWTDecode

class LogInViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    let validate = Validate()
    
    //MARK: - Outlets
    
    @IBOutlet weak var iForgotMyPasswordButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var lpViewEmail: LpCustomView!
    @IBOutlet weak var lpViewPassword: LpCustomView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // to hide error message when view did load
        lpViewEmail.showError = false
        
        //        logInButton.isEnabled = false
        
        // setup forgot button UI
        iForgotMyPasswordButton.setupYellowButtonUI(text: "I forgot my password")
        
        // get any changes in text fields
        lpViewEmail.txtInputField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPassword.txtInputField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        //Check email validation after button pressed
        //        lpViewEmail.checkEmail()
        logInWithAuth0()
        coordinator?.goToHomeVC()
    }
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        // Push to CreateAccount VC
        coordinator?.goToCreateAccountVC()
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        // Push to ForgotPassword VC
        coordinator?.goToForgotPasswordVC()
    }
    
    //MARK: - Log In Methods
    
    // make log in with
    func logInWithAuth0() {
        guard let email = lpViewEmail.txtInputField.text,
              let password = lpViewPassword.txtInputField.text else {return}
        
        Auth0Manager.shared.loginWithEmail(email, password: password) { result in
            switch result {
            case .success(let accessToken):
                print("Access Token: \(String(describing: accessToken))")
            case .failure(let error):
                
                switch error {
                case .missingEmail:
                    print(error.localizedDescription)
                case .missingPassword:
                    print(error.localizedDescription)
                case .error(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    //MARK: - Validation Methods
    
    // Check email validation while typing in text field
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkEmailAndPassword()
        reloadInputViews()
    }
    
    // check if email and password were written correct
    // if yes - button isEnabled and color is Yellow
    // if no  - button !isEnamble and color is Gray
    func checkEmailAndPassword() {
        guard let email = lpViewEmail.txtInputField.text,
              let password = lpViewPassword.txtInputField.text else {return}
        
        if validate.validateEmail.validateEmailId(emailID: email) == true, password.count >= 6 {
            self.logInButton.backgroundColor = UIColor.appColor(LPColor.WarningYellow)
            logInButton.isEnabled = true
        }
        else {
            logInButton.isEnabled = false
            self.logInButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
        }
    }
}
