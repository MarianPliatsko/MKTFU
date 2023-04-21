//
//  SuccessViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-03.
//

import UIKit
import SwiftyGif

class SuccessViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
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
            let gif = try UIImage(gifName: "animated checkmark.gif")
            self.imageView.setGifImage(gif)
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
// ----------> Why self?.coordinator.goToHomeVC(user: nil) doesnt work ????? <----------
                self?.navigationController?.popToRootViewController(animated: true)
            }
        } catch {
            print(error)
        }
    }
}
