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
    let validate = Validate()
    let keyChain = KeychainSwift()
    
    //MARK: - Outlets
    
    @IBOutlet weak var iForgotMyPasswordButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var lpViewEmail: LpCustomView!
    @IBOutlet weak var lpViewPassword: LpCustomView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpViewEmail.txtInputField.text = "marianpliatsko+4@gmail.com"
        lpViewPassword.txtInputField.text = "Launchpad1!"
        lpViewEmail.showError = false
        iForgotMyPasswordButton.setupYellowButtonUI(text: "I forgot my password")
        
        //        logInButton.isEnabled = false
        
        // get any changes in text fields
        lpViewEmail.txtInputField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPassword.txtInputField.addTarget(self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - Actions
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        //        lpViewEmail.checkEmail()
        logInButton.isEnabled = false
        logInWithAuth0()
    }
    @IBAction func createAccountButtonPressed(_ sender: UIButton) {
        coordinator?.goToCreateAccountVC()
    }
    @IBAction func forgotPasswordButtonPressed(_ sender: UIButton) {
        coordinator?.goToForgotPasswordVC()
    }
    
    //MARK: - Log In Methods
    
    func logInWithAuth0() {
        guard let email = lpViewEmail.txtInputField.text,
              let password = lpViewPassword.txtInputField.text else {return}
        
        Auth0Manager.shared.loginWithEmail(email: email, password: password) { result in
            switch result {
            case .success(let accessToken):
                if accessToken != nil {
                    self.keyChain.set(accessToken!, forKey: KeychainConstants.accessTokenKey)
                    print("Access Token: \(String(describing: accessToken))")
                    self.getUserID(accessToken: accessToken!)
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
    
    func getUserID(accessToken: String) {
        Auth0Manager.shared.getUserID(accessToken: accessToken) { result in
            switch result {
            case .success(let userID):
                if userID != nil {
                    guard let encodedUserId = userID?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                        print("Error when encode the userID")
                        return
                    }
                    self.keyChain.set(userID ?? "", forKey: KeychainConstants.userIDKey)
                    self.keyChain.set(encodedUserId, forKey: KeychainConstants.encodedUserIDKey)
                    self.keyChain.set(accessToken, forKey: KeychainConstants.accessTokenKey)
                    print("Encoded User id: \(encodedUserId)")
                    self.getUserCredential(token: accessToken, userID: userID!)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getUserCredential(token: String, userID: String) {
        NetworkManager.shared.request(endpoint: "api/User/\(userID)",
                                      type: User.self,
                                      token: token,
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    print(user)
                    self.coordinator?.goToHomeVC(user: user)
                }
            case .failure(let error):
                print(error)
            }
            logInButton.isEnabled = true
        }
    }
    
    //MARK: - Validation Methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        checkEmailAndPassword()
        reloadInputViews()
    }
    
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
