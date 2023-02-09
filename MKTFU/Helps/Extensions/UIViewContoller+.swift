//
//  File.swift
//  MKTFU
//
//  Created by mac on 2023-02-07.
//

import Foundation
import UIKit

extension UIViewController {
    
    func createNavigationController(rootViewController: UIViewController) {
        let nc = UINavigationController(rootViewController: rootViewController)
        UIApplication.shared.windows.first?.rootViewController = nc
       
    }
    
    func pushToVC(name: String, identifier: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(vc,animated: true)
    }
}
