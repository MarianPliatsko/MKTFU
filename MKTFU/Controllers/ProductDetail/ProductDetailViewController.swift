//
//  ProductDetailViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-15.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    private let images: [UIImage] = Array(1...11).map { UIImage(named: String($0))!}
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        for image in images {
            imageView.image = image
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
