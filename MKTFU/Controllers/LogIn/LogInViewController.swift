//
//  ViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-30.
//

import UIKit

class LogInViewController: UIViewController {
    
    weak var coordinator: MainCoordinator?
    private let alert = CustomAlertView()
    private let logInService = LoginService()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var iForgotMyPasswordButton: UIButton!
    @IBOutlet private weak var logInButton: UIButton!
    @IBOutlet private weak var lpViewEmail: LpCustomView!
    @IBOutlet private weak var lpViewPassword: LpCustomView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTextField()
        dismissKeyBoard()
    }
    
    //MARK: - Actions
    
    @IBAction private func logInButtonPressed(_ sender: UIButton) {
        disableLoginButton()
        logInWithAuth0()
    }
    @IBAction private func createAccountButtonPressed(_ sender: UIButton) {
        coordinator?.goToCreateAccountVC()
    }
    @IBAction private func forgotPasswordButtonPressed(_ sender: UIButton) {
        coordinator?.goToForgotPasswordVC()
    }
    
    //MARK: - Methods
    
    private func dismissKeyBoard() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    private func setupTextField() {
        lpViewEmail.txtInputField.delegate = self
        lpViewPassword.txtInputField.delegate = self
        lpViewEmail.txtInputField.addTarget(
            self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPassword.txtInputField.addTarget(
            self, action: #selector(LogInViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func setupUI() {
        lpViewEmail.txtInputField.text = "marianpliatsko+4@gmail.com"
        lpViewPassword.txtInputField.text = "Newpassword1!"
        lpViewEmail.showError = false
        iForgotMyPasswordButton.setupYellowButtonUI(text: "I forgot my password")
        disableLoginButton()
    }
    
    //MARK: - Log In Methods
    
    private func logInWithAuth0() {
        guard let email = lpViewEmail.txtInputField.text,
              let password = lpViewPassword.txtInputField.text else {return}
        
        logInService.login(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.enableLoginButton()
                    self?.coordinator?.goToHomeVC(user: user)
                }
            case .failure(let error):
                self?.handleLoginError(error: error)
            }
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
    
    private func handleLoginError(error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.enableLoginButton()
            self?.showAlert(message: error.localizedDescription, tryAgain: {
                self?.logInWithAuth0()
            })
        }
    }
    
    //MARK: - Validation Methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        checkEmailAndPassword()
    }
    
    private func checkEmailAndPassword() {
        if let email = lpViewEmail.txtInputField.text,
           let password = lpViewPassword.txtInputField.text,
           email.validate(regEX: ValidationConstants.email),
           password.count >= 6 {
            self.enableLoginButton()
        } else {
            self.disableLoginButton()
        }
    }
    
    private func enableLoginButton() {
        logInButton.isEnabled = true
        self.logInButton.backgroundColor = UIColor.appColor(LPColor.WarningYellow)
    }
    
    private func disableLoginButton() {
        logInButton.isEnabled = false
        self.logInButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
    }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
