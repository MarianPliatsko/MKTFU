//
//  ForgotPasswordVerificationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-06.
//

import UIKit

class ForgotPasswordCompleteViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?

    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: - Actions
    
    @IBAction func returnToLoginScreenBtnPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    //MARK: - Methods
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
