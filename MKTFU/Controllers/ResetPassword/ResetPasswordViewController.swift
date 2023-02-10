//
//  ResetPasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import UIKit

class ResetPasswordViewController: UIViewController {
    
    //MARK: - Properties
    
    let validate = Validate()
    
    //MARK: Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    
    @IBOutlet weak var lpViewPassword: LpCustomView!
    @IBOutlet weak var lpViewConfirmPassword: LpCustomView!
    
    @IBOutlet weak var sixCharactersImageView: UIImageView!
    @IBOutlet weak var oneUppercaseImageView: UIImageView!
    @IBOutlet weak var oneNumberImageView: UIImageView!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButton.isEnabled = false
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        lpViewPassword.txtInputField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewConfirmPassword.txtInputField.addTarget(self, action: #selector(CreatePasswordViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPassword.lblPasswordSecurityLevel.isHidden = true
    }
    
    //MARK: - Actions
    
    @IBAction func checkMarkTermsAndPolicyButton(_ sender: UIButton) {
        pushToVC(name: "Success", identifier: "SuccessViewController")
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
            print("InvalidPassword")
        }
        
        let sixCharacters = validate.validateString.validateString(regEX: "^.{6,}$",
                                                                   password: password)
        if sixCharacters == false {
            sixCharactersImageView.image = UIImage(named: "Icon awesome-check-circle")
            lpViewPassword.lblPasswordSecurityLevel.isHidden = true
            reloadInputViews()
        } else {
            sixCharactersImageView.image = UIImage(named: "Icon awesome-check-circle-fill")
            lpViewPassword.lblPasswordSecurityLevel.isHidden = false
            lpViewPassword.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.WarningYellow)
            lpViewPassword.lblPasswordSecurityLevel.text = "Weak"
            reloadInputViews()
        }
        
        let oneUppercase = validate.validateString.validateString(regEX: ".*[A-Z]+.*",
                                                                  password: password)
        if oneUppercase == false {
            oneUppercaseImageView.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneUppercaseImageView.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        let oneNumber = validate.validateString.validateString(regEX: ".*[0-9]+.*",
                                                               password: password)
        if oneNumber == false {
            oneNumberImageView.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneNumberImageView.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        if sixCharacters == true, oneUppercase == true, oneNumber == true {
            lpViewPassword.lblPasswordSecurityLevel.isHidden = false
            lpViewPassword.lblPasswordSecurityLevel.textColor = UIColor.appColor(LPColor.GoodJobGreen)
            lpViewPassword.lblPasswordSecurityLevel.text = "Strong"
            reloadInputViews()
        }
        
        if validPassword == true, password == confirmPassword, sixCharacters == true, oneUppercase == true, oneNumber == true {
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
}
