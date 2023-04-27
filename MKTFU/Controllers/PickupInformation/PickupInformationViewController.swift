//
//  PickupInformationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-10.
//

import UIKit

enum PickupInformationMode {
    case fromCheckout
    case fromPurchases
}

class PickupInformationViewController: UIViewController {
    
    //MARK: - Prooperties
    
    weak var coordinator: MainCoordinator?
    var product: Product?
    var mode: PickupInformationMode!
    
    //MARK: - Outlet
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var prooductNameLabel: UILabel!
    @IBOutlet private weak var productPickupInformationLabel: UILabel!
    @IBOutlet private weak var sellerNameLabel: UILabel!
    @IBOutlet private weak var sellerNameSecondLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var contactSellerButton: UIButton!
    
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        setupUI(data: product!, mode: mode)
    }
    
    //MARK: - IBAction
    
    @IBAction private func closeBtnPressed(_ sender: UIButton) {
        coordinator?.goToSuccessVC()
    }
    
    //MARK: - Methods
    
    func setupMode(mode: PickupInformationMode) {
        self.mode = mode
    }
    
    private func setup() {
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        productImageView.layer.cornerRadius = productImageView.layer.bounds.width / 2
        productImageView.clipsToBounds = true
    }
    
    private func showCloseButtonAndContactSellerButton() {
        closeButton.isHidden = false
        contactSellerButton.isHidden = false
    }
    
    private func hideCloseButtonAndContactSellerButton() {
        closeButton.isHidden = true
        contactSellerButton.isHidden = true
    }
    
    private func setupUI(data: Product, mode: PickupInformationMode) {
        switch mode {
        case .fromCheckout:
            showCloseButtonAndContactSellerButton()
        case .fromPurchases:
            hideCloseButtonAndContactSellerButton()
        }
        prooductNameLabel.text = data.productName
        productPickupInformationLabel.text = "\(data.address), \(data.city)"
        sellerNameLabel.text = "\(data.sellerProfile?.firstName ?? "") \(data.sellerProfile?.lastName ?? "")"
        sellerNameSecondLabel.text = sellerNameLabel.text
        
        NetworkManager.shared.getImage(from: data.images[0],
                                       imageView: productImageView) { [weak self] result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self?.productImageView = image
                }
            case .failure(_):
                break
            }
        }
    }
}
