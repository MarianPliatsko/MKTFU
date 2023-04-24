//
//  ForgotPasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit
import Auth0

class ForgotPasswordViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private let validate = Validate()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var lpViewEmail: LpCustomView!
    @IBOutlet private weak var sentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        lpViewEmail.txtInputField.delegate = self
        lpViewEmail.txtInputField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: - IBActions
    
    @IBAction private func sendButtonPressed(_ sender: UIButton) {
        resetPassword()
    }
    
    //MARK: - Methods
    
    private func resetPassword() {
        guard let email = lpViewEmail.txtInputField.text else {return}
        Auth0Manager().resetPassword(email) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.coordinator?.goToForgotPasswordCompleteVC()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    
    //MARK: - Validation methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let email = lpViewEmail.txtInputField.text else {return}
        
        let isValidateEmail = validate.validateEmail.validateEmailId(emailID: email)
        if isValidateEmail == false {
            sentButton.isEnabled = false
        } else {
            sentButton.isEnabled = true
        }
        reloadInputViews()
    }
}
