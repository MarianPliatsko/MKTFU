//
//  Home.swift
//  MKTFU
//
//  Created by mac on 2023-03-15.
//

import Foundation
import UIKit

struct Home {
    var city: [City]
    var productImage: [ProductImage]
}

struct ProductImage {
    var image: UIImage
}

extension ProductImage {
    static var images = [ProductImage(image: UIImage(named: "Path 2") ?? UIImage()),
                         ProductImage(image: UIImage(named: "Path 4") ?? UIImage()),
                         ProductImage(image: UIImage(named: "Path 7") ?? UIImage()),
                         ProductImage(image: UIImage(named: "Path 9") ?? UIImage()),
                         ProductImage(image: UIImage(named: "Path 5") ?? UIImage())]
}
