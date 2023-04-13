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
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var productImageView: UIImageView! {
        didSet {
            productImageView.layer.cornerRadius = productImageView.layer.bounds.width / 2
            productImageView.clipsToBounds = true
        }
    }
    @IBOutlet weak var prooductNameLabel: UILabel!
    @IBOutlet weak var productPickupInformationLabel: UILabel!
    
    //MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        setupUI(data: product!)
    }
    
    //MARK: - IBAction
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        coordinator?.goToSuccessVC()
    }
    
    //MARK: - Methods
    
    func setupUI(data: Product) {
        prooductNameLabel.text = data.productName
        productPickupInformationLabel.text = "\(data.address), \(data.city)"
        
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
