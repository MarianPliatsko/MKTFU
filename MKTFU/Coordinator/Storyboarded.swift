//
//  Storyboarded.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate(name: String) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(name: String) -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: name, bundle: Bundle.main)
        
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}

extension UIViewController: Storyboarded {}
