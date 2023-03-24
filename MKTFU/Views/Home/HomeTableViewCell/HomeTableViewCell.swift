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
    
    @IBOutlet weak var cityNameLabel: UILabel!
    
    //MARK: - Nib Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    
    // create nib
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    // setup cell
//    func setupCell(data: : String) {
//        cityNameLabel.text = city
//    }
}
