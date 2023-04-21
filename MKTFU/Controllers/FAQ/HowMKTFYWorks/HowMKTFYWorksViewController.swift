//
//  HowMKTFYWorksViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit

class HowMKTFYWorksViewController: UIViewController, Storyboarded {

    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var faq: FAQ!
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var faqQuestionLabel: UILabel!
    @IBOutlet weak var faqAnswerTextView: UITextView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Methods
    
    func setup(faq: FAQ) {
        self.faq = faq
    }
    
    private func setupUI() {
        faqQuestionLabel.text = faq.question
        faqAnswerTextView.text = faq.answer.removeHtmlTagsFromUrlEncodedString()
    }
}
