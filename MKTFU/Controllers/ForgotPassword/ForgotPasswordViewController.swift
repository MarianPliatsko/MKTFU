//
//  ForgotPasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - Properties
    
    let validate = Validate()
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var lpViewEmail: LpCustomView!
    @IBOutlet weak var sentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        lpViewEmail.txtInputField.delegate = self
        lpViewEmail.txtInputField.addTarget(self, action: #selector(ForgotPasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
    }
    
    //MARK: Actions
    
    @IBAction func sendButtonPressed(_ sender: UIButton) {
        pushToVC(name: "ForgotPasswordVerification", identifier: "ForgotPasswordVerificationViewController")
    }
    
    //MARK: - Validation methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
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
