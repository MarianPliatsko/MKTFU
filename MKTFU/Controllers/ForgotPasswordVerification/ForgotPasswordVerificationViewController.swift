//
//  ForgotPasswordVerificationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit

class ForgotPasswordVerificationViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var cerificationCodeTextField: UITextField!
    @IBOutlet weak var verificationErrorLabel: UILabel!
    @IBOutlet weak var didntRecieveTheCode: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adjustForgotPasswordButton()
        verificationErrorLabel.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    //MARK: - Actions
    
    
    @IBAction func didntRecieveCodeButtonPressed(_ sender: UIButton) {
    }
    
    @IBAction func verifyButtonPressed(_ sender: UIButton) {
    }
    
    
    // MARK: - UI setup methods
    
    // Make underline fot button text and adjust
    func adjustForgotPasswordButton() {
        let attributedTitle = NSAttributedString(
            string: "I didn’t receive the code, send it again",
            attributes: [
                .foregroundColor: UIColor.appColor(LPColor.WarningYellow)!,
                .font: UIFont(name: "OpenSans", size: 14)!,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        didntRecieveTheCode.setAttributedTitle(attributedTitle, for: .normal)
    }

}
