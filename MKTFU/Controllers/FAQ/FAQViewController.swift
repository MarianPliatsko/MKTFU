//
//  FAQViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import KeychainSwift

class FAQViewController: UIViewController {

    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var faq: [FAQ] = []
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var faqTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupTableView()
        getFAQs()
    }

    //MARK: - Methods
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setupTableView() {
        faqTableView.delegate = self
        faqTableView.dataSource = self
        faqTableView.register(FAQTableViewCell.nib(),
                              forCellReuseIdentifier: FAQTableViewCell.identifier)
    }
    
    private func getFAQs() {
        NetworkManager.shared.request(endpoint: EndpointConstants.getFAQ,
                                      type: [FAQ].self,
                                      token: KeychainSwift().get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { result in
            switch result {
            case .success(let faq):
                DispatchQueue.main.async {
                    self.faq = faq
                    self.faqTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - extension FAQViewController: UITableViewDelegate, UITableViewDataSource

extension FAQViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        faq.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = faqTableView.dequeueReusableCell(withIdentifier: FAQTableViewCell.identifier, for: indexPath) as? FAQTableViewCell else {return UITableViewCell()}
        cell.setupUI(faq: faq[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.goToHowMKTFYWorksViewController(faq: faq[indexPath.row])
    }
    
    
}
