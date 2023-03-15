//
//  FAQViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit

class FAQViewController: UIViewController, Storyboarded {

    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func howMKTFYWorksBtnPressed(_ sender: UIButton) {
        coordinator?.goToHowMKTFYWorksViewController()
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
