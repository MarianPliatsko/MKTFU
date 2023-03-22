//
//  NotificationsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-21.
//

import UIKit

class NotificationsViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var notificationsTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        
        notificationsTableView.register(NotificationsTableViewCell.nib(),
                                        forCellReuseIdentifier: NotificationsTableViewCell.identifier)
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

    //MARK: - extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionText = NotificationSectionHeaderView()
        switch section {
        case 0:
            sectionText.sectionTextLabel.text = "New for you"
            return sectionText
        case 1:
            sectionText.sectionTextLabel.text = "Previously seen"
            return sectionText
        default:
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notificationsTableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.identifier, for: indexPath) as? NotificationsTableViewCell else {return UITableViewCell()}
        switch indexPath.section {
        case 0:
            cell.backgroundColor = UIColor.appColor(LPColor.VoidWhite)
            return cell
        case 1:
            cell.backgroundColor = UIColor.appColor(LPColor.VerySubtleGray)
            return cell
        default:
            return UITableViewCell()
        }
    }
}
