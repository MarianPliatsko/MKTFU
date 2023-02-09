//
//  EmailVerificationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import UIKit

class EmailVerificationViewController: UIViewController {
    
    //MARK: - Outlets
    
    @IBOutlet weak var didntRecieveTheMailButton: UIButton!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Make underline fot button text and adjust
        didntRecieveTheMailButton.setupYellowButtonUI(text: "I didn’t receive the code, send it again")
    }
    
    //MARK: - Actions
    
    @IBAction func didntRecieveTheMailButtonPressed(_ sender: UIButton) {
    }
}
