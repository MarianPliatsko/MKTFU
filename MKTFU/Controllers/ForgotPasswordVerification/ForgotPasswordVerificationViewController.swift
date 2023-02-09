//
//  ForgotPasswordVerificationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit

class ForgotPasswordVerificationViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpViewVerificationCode: LpCustomView!
    @IBOutlet weak var didntRecieveTheCode: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make underline fot button text and adjust
        didntRecieveTheCode.setupYellowButtonUI(text: "I didn’t receive the code, send it again")
        lpViewVerificationCode.showError = false
    }
    
    //MARK: - Actions
    
    @IBAction func didntRecieveCodeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
    }
}
