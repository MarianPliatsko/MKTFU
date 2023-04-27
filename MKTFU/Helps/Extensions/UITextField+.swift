////
////  UITextField+.swift
////  MKTFU
////
////  Created by mac on 2023-01-31.
////
//

import UIKit

extension UITextField {
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: -20, y: 0, width: 10.0, height: 10.0)
        mainView.addSubview(imageView)
        
        if(Direction.Left == direction){ // image left
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
}
