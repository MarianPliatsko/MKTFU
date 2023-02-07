//
//  EmailVerificationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    
    @IBOutlet weak var didntRecieveTheMailButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       adjustForgotPasswordButton()
    }
    
    @IBAction func didntRecieveTheMailButtonPressed(_ sender: UIButton) {
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
        didntRecieveTheMailButton.setAttributedTitle(attributedTitle, for: .normal)
    }


}
