//
//  UIImageView+.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import Foundation
import UIKit

extension UIImageView {
    
    func round(corners: UIRectCorner, cornerRadius: Double) {
        let size = CGSize(width: cornerRadius,
                          height: cornerRadius)
        let bezierPath = UIBezierPath(roundedRect: self.bounds,
                                      byRoundingCorners: corners,
                                      cornerRadii: size)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = bezierPath.cgPath
        self.layer.mask = shapeLayer
    }
}
