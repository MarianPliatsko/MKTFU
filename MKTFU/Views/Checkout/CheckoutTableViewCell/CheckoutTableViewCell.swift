//
//  CheckoutTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-09.
//

import UIKit

class CheckoutTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "CheckoutTableViewCell"
    
    //MARK: - Outlets
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    //MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI (image: String, title: String, price: Double) {
        productTitle.text = title
        productPrice.text = "\(price)$"
        
        NetworkManager.shared.getImage(from: image, imageView: productImageView) { result in
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
