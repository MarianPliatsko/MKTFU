//
//  MainCoordinator.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCooerdinator: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = LogInViewController()
        navigationController.pushViewController(vc, animated: true)
    }
    
    
}
