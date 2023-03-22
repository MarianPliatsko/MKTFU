//
//  NotificationsTableViewCell.swift
//  MKTFU
//
//  Created by mac on 2023-03-21.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    static let identifier = "NotificationsTableViewCell"
    
    //MARK: - Outlets
    
    
    
    //MARK: - Lifecycle

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
    
}
