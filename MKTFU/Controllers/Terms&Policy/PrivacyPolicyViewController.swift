//
//  PrivacyPolicyViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    //MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        dismissVC()
    }
    
    //MARK: - Navigation methods
    
    func dismissVC() {
        dismiss(animated: true)
    }
}