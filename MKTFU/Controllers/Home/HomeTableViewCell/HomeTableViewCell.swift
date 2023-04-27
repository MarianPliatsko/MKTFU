//
//  HomeTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-23.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "HomeTableViewCell"
    
    //MARK: - Outlets
    
    @IBOutlet private weak var cityNameLabel: UILabel!
    
    //MARK: - Nib Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setupUI(city: String) {
        cityNameLabel.text = city
    }
}
