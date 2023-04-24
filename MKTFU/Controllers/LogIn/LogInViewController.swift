//
//  ViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-30.
//

import UIKit
import Auth0
import JWTDecode
import KeychainSwift

class LogInViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    private let validate = Validate()
    private let keyChain = KeychainSwift()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var iForgotMyPasswordButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var lpViewEmail: LpCustomView!
    @IBOutlet private weak var lpViewPassword: LpCustomView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        // get any changes in text fields
        lpViewEmail.txtInputField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPassword.txtInputField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @IBAction private func logInButtonPressed(_ sender: UIButton) {
        lpViewEmail.checkEmail()
        loginButtonIsNotActive()
        logInWithAuth0()
    }
    @IBAction private func createAccountButtonPressed(_ sender: UIButton) {
        coordinator?.goToCreateAccountVC()
    }
    @IBAction private func forgotPasswordButtonPressed(_ sender: UIButton) {
        coordinator?.goToForgotPasswordVC()
    }
    
    //MARK: - Methods
    
    private func setupUI() {
        lpViewEmail.txtInputField.text = "marianpliatsko+4@gmail.com"
        lpViewPassword.txtInputField.text = "Newpassword2!"
        lpViewEmail.showError = false
        iForgotMyPasswordButton.setupYellowButtonUI(text: "I forgot my password")
        loginButtonIsNotActive()
    }
    
    private func loginButtonIsActive() {
        logInButton.isEnabled = true
        self.logInButton.backgroundColor = UIColor.appColor(LPColor.WarningYellow)
    }
    
    private func loginButtonIsNotActive() {
        logInButton.isEnabled = false
        self.logInButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
    }
    
    //MARK: - Log In Methods
    
    private func logInWithAuth0() {
        guard let email = lpViewEmail.txtInputField.text,
              let password = lpViewPassword.txtInputField.text else {return}
        
        Auth0Manager.shared.loginWithEmail(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let accessToken):
                if accessToken != nil {
                    self?.keyChain.set(accessToken!, forKey: KeychainConstants.accessTokenKey)
                    print("Access Token: \(String(describing: accessToken))")
                    self?.keyChain.set(password, forKey: "Password")
                    DispatchQueue.main.async {
                        self?.getUserID(accessToken: accessToken!)
                    }
                }
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
    
    private func getUserID(accessToken: String) {
        Auth0Manager.shared.getUserID(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let userID):
                if userID != nil {
                    guard let encodedUserId = userID?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                        print("Error when encode the userID")
                        return
                    }
                    self?.keyChain.set(userID ?? "", forKey: KeychainConstants.userIDKey)
                    self?.keyChain.set(encodedUserId, forKey: KeychainConstants.encodedUserIDKey)
                    self?.keyChain.set(accessToken, forKey: KeychainConstants.accessTokenKey)
                    print("Encoded User id: \(encodedUserId)")
                    DispatchQueue.main.async {
                        self?.getUserCredential(token: accessToken, userID: userID!)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func getUserCredential(token: String, userID: String) {
        NetworkManager.shared.request(endpoint: "api/User/\(userID)",
                                      type: User.self,
                                      token: token,
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.coordinator?.goToHomeVC(user: user)
                }
            case .failure(let error):
                print(error)
            }
            DispatchQueue.main.async {
                self?.loginButtonIsActive()
            }
        }
    }
    
    //MARK: - Validation Methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkEmailAndPassword()
        reloadInputViews()
    }
    
    private func checkEmailAndPassword() {
        guard let email = lpViewEmail.txtInputField.text,
              let password = lpViewPassword.txtInputField.text else {return}
        
        if validate.validateEmail.validateEmailId(emailID: email) == true, password.count >= 6 {
            self.loginButtonIsActive()
        }
        else {
            self.loginButtonIsNotActive()
        }
    }
}
