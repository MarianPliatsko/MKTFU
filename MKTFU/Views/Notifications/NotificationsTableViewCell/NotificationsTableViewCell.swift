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
    
    @IBOutlet private weak var notificationMessageLabel: UILabel!
    @IBOutlet private weak var notificationDateLabel: UILabel!
    
    //MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: - Methods
    
    static func nib() -> UINib {
        let nib = UINib(nibName: identifier, bundle: nil)
        return nib
    }
    
    func setup(model: Notification) {
        notificationMessageLabel.text = model.message
        notificationDateLabel.text = model.created.formatDate(
            from: "yyyy-MM-dd'T'HH:mm:ss.SSSSS'Z'",
            to: "MMMM dd yyyy")
    }
}
