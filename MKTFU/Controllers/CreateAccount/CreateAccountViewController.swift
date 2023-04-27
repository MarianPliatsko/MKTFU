//
//  CreateAccountViewController.swift
//  MKTFU
//
//  Created by mac on 2023-01-31.
//

import UIKit
import Auth0

class CreateAccountViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private let validate = Validate()
    private let cityDataSource = City.cities
    private let thePicker = UIPickerView()
    private var isValideCity: Bool = false
    private var isValidePhone: Bool = false
    var user = User()
    private var lpCustomView = LpCustomView()
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var lpViewFirstName: LpCustomView!
    @IBOutlet private weak var lpViewLastName: LpCustomView!
    @IBOutlet private weak var lpViewEmail: LpCustomView!
    @IBOutlet private weak var lpViewPhone: LpCustomView!
    @IBOutlet private weak var lpViewPickupAddress: LpCustomView!
    @IBOutlet private weak var lpViewCityName: LpCustomView!
    @IBOutlet private weak var createButton: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLPView()
        setupButtons()
        setupPickerView()
        initializeHideKeyboard()
        setupToolbar()
    }
    
    //MARK: - Actions
    
    @IBAction private func loginButtonPressed(_ sender: UIButton) {
        createUser()
        coordinator?.goToCreatePasswordVC(user: user)
    }
    
    //MARK: - Methods
    
    private func setupLPView() {
        lpViewPhone.txtInputField.delegate = self
        lpViewCityName.txtInputField.delegate = self
        lpViewFirstName.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewLastName.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewEmail.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPhone.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewPickupAddress.txtInputField.addTarget(self, action: #selector(CreateAccountViewController.textFieldDidChange(_:)), for: .editingChanged)
        lpViewCityName.txtInputField.addTarget(self,action: #selector(CreateAccountViewController.textFieldDidChange(_:)),
            for: .editingDidBegin)
        lpViewCityName.txtInputField.withImage(direction: .Right,
                                               image: UIImage(
                                                named: ImageNameConstrants.dropDown) ?? UIImage(),
                                               colorSeparator: UIColor.orange,
                                               colorBorder: UIColor.black)
    }
    
    private func setupPickerView() {
        thePicker.delegate = self
        lpViewCityName.txtInputField.inputView = thePicker
    }
    
    private func setupButtons() {
        createButton.isEnabled = false
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupToolbar() {
        let bar = UIToolbar()
        let doneBtn = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissMyKeyboard))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        bar.items = [flexSpace, flexSpace, doneBtn]
        bar.sizeToFit()
        lpViewPhone.txtInputField.inputAccessoryView = bar
        lpViewPhone.txtInputField.keyboardType = .numberPad
    }
        
    private func initializeHideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard() {
        view.endEditing(true)
    }
    
    private func createUser() {
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
    }
        
    // MARK: - Validation Methods
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let firstName = lpViewFirstName.txtInputField.text,
              let lastName = lpViewLastName.txtInputField.text,
              let email = lpViewEmail.txtInputField.text,
              let address = lpViewPickupAddress.txtInputField.text else {return}
         
        let isValidateFirstName = firstName.validate(regEX: ValidationConstants.name)
        let isValidateLastName = lastName.validate(regEX: ValidationConstants.name)
        let isValidateEmail = email.validate(regEX: ValidationConstants.email)

        if isValidateFirstName, isValidateLastName,
            isValidateEmail, !address.isEmpty, isValideCity == true, isValidePhone == true {
            createButtonIsActive()
        } else {
            createButtonIsNotActive()
        }
    }
    
    private func createButtonIsActive() {
        createButton.isEnabled = true
        createButton.backgroundColor = UIColor.appColor(LPColor.WarningYellow)
        createButton.setTitle("Next", for: .normal)
    }
    
    private func createButtonIsNotActive() {
        createButton.isEnabled = false
        createButton.backgroundColor = UIColor.appColor(LPColor.DisabledGray)
        createButton.setTitle("Login", for: .normal)
    }
    
    private func setCity(_ city: City) {
        lpViewCityName.txtInputField.text = city.localizedTitle
        if lpViewCityName.txtInputField.text != "" {
            isValideCity = true
            textFieldDidChange(lpViewCityName.txtInputField)
        } else {
            isValideCity = false
        }
    }
}

// MARK: - Extension CreateAccountViewController: UITextFieldDelegate

extension CreateAccountViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        let newString = (text as NSString).replacingCharacters(in: range, with: string)
        textField.text = newString.validatePhoneNumber()
        switch textField.text?.count == 17 {
        case true:
            isValidePhone = true
            textFieldDidChange(lpViewPhone.txtInputField)
        case false:
            isValidePhone = false
            textFieldDidChange(lpViewPhone.txtInputField)
        }
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if lpViewCityName.txtInputField.text?.isEmpty == true {
            setCity(cityDataSource[0])
        }
    }
}

// MARK: - Extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource

extension CreateAccountViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return cityDataSource.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cityDataSource[row].localizedTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setCity(cityDataSource[row])
    }
}
