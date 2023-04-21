//
//  NotificationsViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-21.
//

import UIKit
import KeychainSwift

struct NotificationSection {
    let isNew: Bool
    var notifications: [Notification]
}

class NotificationsViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    private var notificationSections: [NotificationSection]?
    
    //MARK: - Outlets
    
    @IBOutlet private weak var lpHeaderView: LPHeaderView!
    @IBOutlet private weak var notificationsTableView: UITableView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        getAllNotifications()
        
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - Methods
    
    private func setupTableView() {
        notificationsTableView.delegate = self
        notificationsTableView.dataSource = self
        notificationsTableView.register(NotificationsTableViewCell.nib(),
                                        forCellReuseIdentifier: NotificationsTableViewCell.identifier)
    }
    
    private func getAllNotifications() {
        NetworkManager.shared.request(endpoint: EndpointConstants.notification,
                                      type: Notifications.self,
                                      token: KeychainSwift().get(KeychainConstants.accessTokenKey) ?? "",
                                      httpMethod: .get,
                                      resultsLimit: nil,
                                      parameters: nil) { [weak self] result in
            switch result {
            case .success(let notification):
                DispatchQueue.main.async {
                    var new: NotificationSection?
                    var seen: NotificationSection?
                    self?.notificationSections = []
                    if notification.new.count == 0 {
                        new = nil
                    } else {
                        new = NotificationSection(isNew: true, notifications: notification.new)
                        self?.notificationSections?.append(new!)
                    }
                    if notification.seen.count == 0 {
                        seen = nil
                    } else {
                        seen = NotificationSection(isNew: false, notifications: notification.seen)
                        self?.notificationSections?.append(seen!)
                    }
                    self?.notificationsTableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource

extension NotificationsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = NotificationSectionHeaderView()
        view.setup(isNew: notificationSections?[section].isNew ?? false)
        return view
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return notificationSections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notificationSections?[section].notifications.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = notificationsTableView.dequeueReusableCell(withIdentifier: NotificationsTableViewCell.identifier, for: indexPath) as? NotificationsTableViewCell else {return UITableViewCell()}
        guard let notifications = notificationSections else {return UITableViewCell()}
        cell.setup(model: notifications[indexPath.section].notifications[indexPath.row])
        return cell
    }
}
