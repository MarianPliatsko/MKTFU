//
//  SuccessViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-03.
//

import UIKit
import SwiftyGif

class SuccessViewController: UIViewController, Storyboarded {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.setHidesBackButton(true, animated: false)
        
        do {
            let gif = try UIImage(gifName: "animated checkmark.gif")
            self.imageView.setGifImage(gif)
            Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
        } catch {
                print(error)
            }
        }
    }
