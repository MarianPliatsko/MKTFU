//
//  SuccessViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-03.
//

import UIKit
import SwiftyGif

class SuccessViewController: UIViewController {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var user = User()
    
    //MARK: - Outlet
    
    @IBOutlet private weak var imageView: UIImageView!
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        showSuccessImage()
    }
    
    //MARK: - Methods
    
    private func showSuccessImage() {
        do {
            let gif = try UIImage(gifName: ImageNameConstrants.animatedCheckmark)
            self.imageView.setGifImage(gif)
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
                self?.coordinator?.goToHomeVC(user: self?.user)
            }
        } catch {
            print(error)
        }
    }
}
