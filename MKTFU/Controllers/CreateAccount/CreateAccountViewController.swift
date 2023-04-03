//
//  CreateAccountViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-31.
//

import UIKit
import Auth0

class CreateAccountViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    let validate = Validate()
    let cityDataSource = City()
    let thePicker = UIPickerView()
    private var isValideCity: Bool = false
    var user = User()
    
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
        
        //call text field delegate
        lpViewPhone.txtInputField.delegate = self
        
        //call to keyboard handling function
        initializeHideKeyboard()
        
        //make done button for phone input
        setupToolbar()
        
//        loginButton.isEnabled = false
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
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
        createUser()
        coordinator?.goToCreatePasswordVC(user: user)
    }
    
    //MARK: - Methods
    
    // Toolbar for Number Pad
    func setupToolbar() {
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        lpViewPhone.txtInputField.inputAccessoryView = bar
        lpViewPhone.txtInputField.keyboardType = .numberPad
    }
        
    // make dismiss for keyboard
    func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    func createUser() {
        let firstName = lpViewFirstName.txtInputField.text
        let lastName = lpViewLastName.txtInputField.text
        let email = lpViewEmail.txtInputField.text
        let phone = lpViewPhone.txtInputField.text
        let address = lpViewPickupAddress.txtInputField.text
        let city = lpViewCityName.txtInputField.text
        
        user = User(userID: "",
                    firstName: firstName ?? "",
                    lastName: lastName ?? "",
                    email: email ?? "",
                    phone: phone ?? "",
                    address: address ?? "",
                    city: city ?? "")
        print("User: \(String(describing: user))")
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
            lpViewCityName.txtInputField.text = cityDataSource.cityList[0]
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
    
    // make return button as next
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        let nextTag = textField.tag + 1
//
//        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
//            nextResponder.becomeFirstResponder()
//        } else {
//            textField.resignFirstResponder()
//        }
//
//        return true
//    }
}

// MARK: - Extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource

extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityDataSource.cityList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityDataSource.cityList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        lpViewCityName.txtInputField.text = cityDataSource.cityList[row]
        if lpViewCityName.txtInputField.text != "" {
            isValideCity = true
            textFieldDidChange(lpViewCityName.txtInputField)
        } else {
            isValideCity = false
        }
        self.view.endEditing(true)
    }
}
