//
//  ForgotPasswordVerificationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit
import Auth0

protocol ForgotPasswordVerificationDelegate: AnyObject {
    func passBearerTocken(_ viewController: ForgotPasswordVerificationViewController,
                          bearerToken: String)
}

class ForgotPasswordVerificationViewController: UIViewController {
    
    weak var delegate: ForgotPasswordVerificationDelegate?
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var lpViewVerificationCode: LpCustomView!
    @IBOutlet weak var didntRecieveTheCode: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        // Make underline fot button text and adjust
        didntRecieveTheCode.setupYellowButtonUI(text: "I didn’t receive the code, send it again")
        lpViewVerificationCode.showError = false
    }
    
    //MARK: - Actions
    
    @IBAction func didntRecieveCodeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
        verifyCode()
        
    }
    
    func verifyCode() {
        Auth0
           .authentication()
           .login(
               email: "marianpliatsko@gmail.com",
               code: lpViewVerificationCode.txtInputField.text!,
               audience: "https://dev-p77zu24vjhtaaicl.us.auth0.com/api/v2/",
               scope: "openid email")
           .start { result in
               switch result {
               case .success(let credentials):
                   DispatchQueue.main.async {
                       self.delegate?.passBearerTocken(self, bearerToken: credentials.accessToken)
                       self.pushToVC(name: "ResetPassword", identifier: "ResetPasswordViewController")
                   }
               case .failure(let error):
                   DispatchQueue.main.async {
                       print("Error:\(error)")
                   }
               }
           }
    }
}
