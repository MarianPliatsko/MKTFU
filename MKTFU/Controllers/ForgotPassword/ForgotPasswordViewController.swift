//
//  ForgotPasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit
import Auth0

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
       forgotPassword()
        pushToVC(name: "ForgotPasswordVerification", identifier: "ForgotPasswordVerificationViewController")
    }
    
    func forgotPassword() {
//        Auth0.authentication().resetPassword(email: lpViewEmail.txtInputField.text ?? "", connection: "Username-Password-Authentication").start { result in
//                    switch result {
//                    case .success(let credentials):
//                      print(credentials)
//                        break
//                    case .failure(let error):
//                        print(error)
//                    }
//                }
        Auth0
           .authentication()
           .startPasswordless(email: "marianpliatsko@gmail.com")
           .start { result in
               switch result {
               case .success:
                   print("Sent OTP to support@auth0.com!")
               case .failure(let error):
                   print(error)
               }
           }
      
        
//        let url = URL(string: "https://dev-p77zu24vjhtaaicl.us.auth0.com/dbconnections/change_password")!
//        var request = URLRequest(url: url)
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.httpMethod = "POST"
//        let parameters: [String: Any] = [
//            "client_id": "1KZC0WwJakXRNiyw15hXTAkG7NiaW64o",
//            "email": lpViewEmail.txtInputField.text!,
//            "connection": "Username-Password-Authentication",
//        ]
//
//        let session = URLSession.shared
//
//        do {
//            // convert parameters to Data and assign dictionary to httpBody of request
//            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
//          } catch let error {
//            print(error.localizedDescription)
//            return
//          }
//
//          // create dataTask using the session object to send data to the server
//          let task = session.dataTask(with: request) { data, response, error in
//
//            if let error = error {
//              print("Post Request Error: \(error.localizedDescription)")
//              return
//            }
//
//            // ensure there is valid response code returned from this HTTP response
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode)
//            else {
//              print("Invalid Response received from the server")
//              return
//            }
            
//            // ensure there is data returned
//            guard let responseData = data else {
//              print("nil Data received from the server")
//              return
//            }
//
//            do {
//              // create json object from data or use JSONDecoder to convert to Model stuct
//              if let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] {
//                print(jsonResponse)
//                // handle json response
//              } else {
//                print("data maybe corrupted or in wrong format")
//                throw URLError(.badServerResponse)
//              }
//            } catch let error {
//              print(error.localizedDescription)
//            }
//          }
//          // perform the task
//          task.resume()
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
