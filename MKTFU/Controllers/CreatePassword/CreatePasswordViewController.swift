//
//  CreatePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-02.
//

import UIKit

class CreatePasswordViewController: UIViewController {
    
    let checkedImage = UIImage(named: "CheckedImage")
    let uncheckedImage = UIImage(named: "UncheckedImage")
    var isChecked: Bool = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var passwordSecurityLevelLabel: UILabel!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    @IBOutlet weak var sixCharactersImage: UIImageView!
    @IBOutlet weak var oneUppercaseImage: UIImageView!
    @IBOutlet weak var oneNumberImage: UIImageView!
    
    @IBOutlet weak var checkMarkTermsAndPolicyButton: UIButton!
    
    @IBOutlet weak var createAccountButton: UIButton!
    
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        print(sender)
    }
    
    
    // MARK: - Methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        guard let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text else {return}
        
        let validPassword = validatePassword(password: password)
        if validPassword == false {
        }
        
        let one = validate(regEX: "^.{6,}$", password: password)
        if one == false {
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
        
        let two = validate(regEX: ".*[A-Z]+.*", password: password)
        if two == false {
            oneUppercaseImage.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneUppercaseImage.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        let three = validate(regEX: ".*[0-9]+.*", password: password)
        if three == false {
            oneNumberImage.image = UIImage(named: "Icon awesome-check-circle")
        } else {
            oneNumberImage.image = UIImage(named: "Icon awesome-check-circle-fill")
        }
        
        if one == true, two == true, three == true {
            passwordSecurityLevelLabel.isHidden = false
            passwordSecurityLevelLabel.textColor = UIColor.appColor(LPColor.GoodJobGreen)
            passwordSecurityLevelLabel.text = "Strong"
            reloadInputViews()
        }
        
         if validPassword == true, password == confirmPassword, one == true, two == true, three == true, isChecked == true {
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
    
    //Change image of check mark
    func checkMarkTapped() {
        isChecked = !isChecked
        
        if isChecked == true {
            checkMarkTermsAndPolicyButton.setImage(checkedImage, for: UIControl.State.normal)
            createAccountButton.backgroundColor = UIColor.appColor(LPColor.OccasionalPurple)
            createAccountButton.isEnabled = true
            reloadInputViews()
        } else {
            checkMarkTermsAndPolicyButton.setImage(uncheckedImage, for: UIControl.State.normal)
            createAccountButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
            createAccountButton.isEnabled = false
            reloadInputViews()
        }
    }
    
    
    func validate(regEX: String, password: String) -> Bool {
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
}








