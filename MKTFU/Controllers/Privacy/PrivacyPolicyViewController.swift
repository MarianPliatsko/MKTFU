//
//  PrivacyPolicyViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-05.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    //MARK: - Actions
    
    @IBAction private func acceptButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
