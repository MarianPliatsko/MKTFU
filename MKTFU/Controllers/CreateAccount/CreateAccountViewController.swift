//
//  CreateAccountViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-31.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    let cityNamesData = ["Calgary",
                         "Edmonton",
                         "Toronto"]
    let thePicker = UIPickerView()
    private var isValidatePhone: Bool = false
    private var isValideCity: Bool = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var pickUpAddressTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginButton.isEnabled = false
        phoneTextField.delegate = self
        
        thePicker.delegate = self
        cityTextField.inputView = thePicker
        
        firstNameTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lastNameTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        pickUpAddressTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        cityTextField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingDidBegin)
        
        cityTextField.withImage(direction: .Right, image: UIImage(named: "Path 123") ?? UIImage(), colorSeparator: UIColor.orange, colorBorder: UIColor.black)
    }
    
    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        showCreatePasswordVC()
    }
    
    //MARK: - Navigation methods
    
    // Show CreateAccount VC
    func showCreatePasswordVC() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "CreatePassword", bundle: nil)
        let createAccountVC = storyBoard.instantiateViewController(withIdentifier: "PasswordViewController")
        createAccountVC.modalPresentationStyle = .fullScreen
        self.show(createAccountVC, sender: self)
    }
    
    // MARK: - Validation Methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let address = pickUpAddressTextField.text else {return}
         
        let isValidateFirstName = validateFirstName(name: firstName)
        if isValidateFirstName == false {
            print("Incorrect FirstName")
        }
        let isValidateLastName = validateLastName(name: lastName)
        if isValidateFirstName == false {
            print("Incorrect LastName")
        }
        let isValidateEmail = validateEmailId(emailID: email)
        if isValidateEmail == false{
            print("Incorrect Email")
        }
        if isValidatePhone == false {
            print("Invalid phone number")
        }
        if pickUpAddressTextField.text?.isEmpty == true {
            print("Incorrect pickup address")
        }
        if isValideCity == false {
            print("Incorrect city")
        }
        if cityTextField.text == nil || cityTextField.text == "" {
            cityTextField.text = cityNamesData[0]
        }
        if isValidateFirstName == true, isValidateLastName == true, isValidateEmail == true, isValidatePhone == true, pickUpAddressTextField.text?.isEmpty == false, isValideCity == true {
            
            loginButton.isEnabled = true
            loginButton.backgroundColor = UIColor.appColor(LPColor.WarningYellow)
            loginButton.setTitle("Next", for: .normal)
            reloadInputViews()
            print("All fields are correct")
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
            loginButton.setTitle("Login", for: .normal)
            reloadInputViews()
        }
        reloadInputViews()
    }
    
    func validateFirstName(name: String) ->Bool {
        // Length be 18 characters max and 3 characters minimum
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        print("isValidateName: \(isValidateName)")
        return isValidateName
    }
    
    func validateLastName(name: String) ->Bool {
        // Length be 18 characters max and 3 characters minimum
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        print("isLastName: \(isValidateName)")
        return isValidateName
    }
    
    func validatePhoneNumber(phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var numberOfElements = 0
        var result = ""
        let mask = "+X (XXX) XXX-XXXX"
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        for _ in 0...result.count {
            numberOfElements += 1
        }
        if numberOfElements == 18 {
            isValidatePhone = true
        } else {
            isValidatePhone = false
        }
        print(result)
        return result
    }
    
//    func validatePickupAddress(adress: String) -> Bool {
//        let adressRegex = "^\\w{3,18}$"
//        let trimmedString = adress.trimmingCharacters(in: .whitespaces)
//        let validateAdress = NSPredicate(format: "SELF MATCHES %@", adressRegex)
//        let isValidateAddress = validateAdress.evaluate(with: trimmedString)
//        print("isValidateAddress: \(isValidateAddress)")
//        return isValidateAddress
//    }
    
    func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        print("isValidateEmail:\(isValidateEmail)")
        return isValidateEmail
    }
}

// MARK: - Extension CreateAccountViewController: UITextFieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = validatePhoneNumber(phone: newString)
            return false
        }
}

// MARK: - Extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource

extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityNamesData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityNamesData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cityTextField.text = cityNamesData[row]
        if cityTextField.text != "" {
            isValideCity = true
            textFieldDidChange(cityTextField)
        } else {
            isValideCity = false
        }
        self.view.endEditing(true)
    }
}
