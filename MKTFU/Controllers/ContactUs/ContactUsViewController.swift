//
//  ContactUsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-14.
//

import UIKit

class ContactUsViewController: UIViewController {

    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var messageTextView: UITextView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupUI()
    }
    
    //MARK: - Methods
    
    private func setup() {
        messageTextView.delegate = self
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        messageTextView.layer.cornerRadius = 15
        messageTextView.textColor = .lightGray
        messageTextView.text = OtherTextConstants.contactUsVCMessagePlaceholder
    }
}

    //MARK: - extension ContactUsViewController: UITextViewDelegate

extension ContactUsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
                textView.text = nil
                textView.textColor = UIColor.black
            }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = OtherTextConstants.contactUsVCMessagePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}
