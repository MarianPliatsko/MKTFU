//
//  PickupInformationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-10.
//

import UIKit

class PickupInformationViewController: UIViewController, Storyboarded {
    
    //MARK: - Prooperties
    
    weak var coordinator: MainCoordinator?
    var product: Product?
    
    //MARK: - Outlet
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var productImageView: UIImageView! {
        didSet {
            productImageView.layer.cornerRadius = productImageView.layer.bounds.width / 2
            productImageView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var prooductNameLabel: UILabel!
    @IBOutlet private weak var productPickupInformationLabel: UILabel!
    @IBOutlet private weak var sellerNameLabel: UILabel!
    @IBOutlet private weak var sellerNameSecondLabel: UILabel!
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        setupUI(data: product!)
    }
    
    //MARK: - IBAction
    
    @IBAction private func closeBtnPressed(_ sender: UIButton) {
        coordinator?.goToSuccessVC()
    }
    
    //MARK: - Methods
    
    private func setupUI(data: Product) {
        prooductNameLabel.text = data.productName
        productPickupInformationLabel.text = "\(data.address), \(data.city)"
        sellerNameLabel.text = "\(data.sellerProfile?.firstName ?? "") \(data.sellerProfile?.lastName ?? "")"
        sellerNameSecondLabel.text = sellerNameLabel.text
        
        NetworkManager.shared.getImage(from: data.images[0],
                                       imageView: productImageView) { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.productImageView = image
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
