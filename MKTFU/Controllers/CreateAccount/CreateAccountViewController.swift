//
//  CreateAccountViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-31.
//

import UIKit

class CreateAccountViewController: UIViewController {
    
    //MARK: - Properties
    
    let validate = Validate()
    
    let cityNamesData = ["Calgary",
                         "Edmonton",
                         "Toronto"]
    let thePicker = UIPickerView()
    
    private var isValideCity: Bool = false
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var lpViewFirstName: LpCustomView!
    @IBOutlet weak var lpViewLastName: LpCustomView!
    @IBOutlet weak var lpViewEmail: LpCustomView!
    @IBOutlet weak var lpViewPhone: LpCustomView!
    @IBOutlet weak var lpViewPickupAddress: LpCustomView!
    @IBOutlet weak var lpViewCityName: LpCustomView!
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loginButton.isEnabled = false
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        //call text field delegate
        lpViewPhone.txtInputField.delegate = self
        
        //call UIPickerView delegate
        thePicker.delegate = self
        lpViewCityName.txtInputField.inputView = thePicker
        
        
        lpViewFirstName.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewLastName.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewEmail.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPhone.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        lpViewPickupAddress.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewCityName.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingDidBegin)
        
        lpViewCityName.txtInputField.withImage(direction: .Right, image: UIImage(named: "Path 123") ?? UIImage(), colorSeparator: UIColor.orange, colorBorder: UIColor.black)
    }
    
    //MARK: - Actions
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        pushToVC(name: "CreatePassword", identifier: "CreatePasswordViewController")
    }
    
    // MARK: - Validation Methods
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let firstName = lpViewFirstName.txtInputField.text,
              let lastName = lpViewLastName.txtInputField.text,
              let email = lpViewEmail.txtInputField.text else {return}
         
        let isValidateFirstName = validate.validateFirstName.validateFirstName(name: firstName)
        if isValidateFirstName == false {
            print("Incorrect FirstName")
        }
        let isValidateLastName = validate.validateLastName.validateLastName(name: lastName)
        if isValidateFirstName == false {
            print("Incorrect LastName")
        }
        let isValidateEmail = validate.validateEmail.validateEmailId(emailID: email)
        if isValidateEmail == false{
            print("Incorrect Email")
        }
        if lpViewPickupAddress.txtInputField.text?.isEmpty == true {
            print("Incorrect pickup address")
        }
        if isValideCity == false {
            print("Incorrect city")
        }
        if lpViewCityName.txtInputField.text == nil || lpViewCityName.txtInputField.text == "" {
            lpViewCityName.txtInputField.text = cityNamesData[0]
        }
        if isValidateFirstName == true, isValidateLastName == true, isValidateEmail == true, lpViewPickupAddress.txtInputField.text?.isEmpty == false, isValideCity == true {
            
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
}

// MARK: - Extension CreateAccountViewController: UITextFieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = validate.validatePhoneNumber.validatePhoneNumber(phone: newString)
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
        lpViewCityName.txtInputField.text = cityNamesData[row]
        if lpViewCityName.txtInputField.text != "" {
            isValideCity = true
            textFieldDidChange(lpViewCityName.txtInputField)
        } else {
            isValideCity = false
        }
        self.view.endEditing(true)
    }
}
