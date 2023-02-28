//
//  Coordinator.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCooerdinator: [Coordinator] {get set}
    var navigationController: UINavigationController {get set}
    
    func start()
}
