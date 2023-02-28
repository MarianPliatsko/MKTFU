//
//  CreateOfferViewController.swift
//  MKTFU
//
//  Created by mac on 2023-02-24.
//

import UIKit

class CreateOfferViewController: UIViewController {

    @IBOutlet weak var lpHeaderView: LPHeaderView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
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
