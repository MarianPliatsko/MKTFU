//
//  PickupInformationViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-10.
//

import UIKit

class PickupInformationViewController: UIViewController, Storyboarded {
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var productImageView: UIImageView! {
        didSet {
            productImageView.layer.cornerRadius = productImageView.layer.bounds.width / 2
            productImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func closeBtnPressed(_ sender: UIButton) {
        coordinator?.goToSuccessVC()
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
