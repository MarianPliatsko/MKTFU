//
//  ContactUsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-14.
//

import UIKit

class ContactUsViewController: UIViewController, Storyboarded {

    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    let messagePlaceholder = "Your message"
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var messageTextView: UITextView! {
        didSet {
            messageTextView.layer.cornerRadius = 15
            messageTextView.textColor = .lightGray
            messageTextView.text = messagePlaceholder
        }
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messageTextView.delegate = self

        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
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
            textView.text = messagePlaceholder
            textView.textColor = UIColor.lightGray
        }
    }
}
