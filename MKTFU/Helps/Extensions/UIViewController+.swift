//
//  UIViewController+.swift
//  MKTFU
//
//  Created by mac on 2023-04-27.
//

import UIKit

extension UIViewController {
    func setupDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
}
