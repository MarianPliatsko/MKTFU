//
//  MainTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lpUIView: LpCustomView!
    
    //MARK: - Properties
    
    static let identifier = "MainTableViewCell"

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
    
    func setupUI(data: CreateOffer, indexPath: IndexPath) {
        lpUIView.title = data.productName[indexPath.row]
    }
    
}
