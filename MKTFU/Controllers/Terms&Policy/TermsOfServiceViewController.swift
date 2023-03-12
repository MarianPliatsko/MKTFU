//
//  TermsOfServiceViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import UIKit

class TermsOfServiceViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Actions
    
    @IBAction func acceptButtonPressed(_ sender: UIButton) {
        coordinator?.goToCreatePasswordVC()
    }
}
