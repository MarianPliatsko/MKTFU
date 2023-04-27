//
//  HowMKTFYWorksViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit

class HowMKTFYWorksViewController: UIViewController {

    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var faq: FAQ!
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var faqQuestionLabel: UILabel!
    @IBOutlet private weak var faqAnswerTextView: UITextView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setup()
        
    }
    
    //MARK: - Methods
    
    func setup(faq: FAQ) {
        self.faq = faq
    }
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupUI() {
        faqQuestionLabel.text = faq.question
        faqAnswerTextView.text = faq.answer.removeHtmlTagsFromUrlEncodedString()
    }
}
