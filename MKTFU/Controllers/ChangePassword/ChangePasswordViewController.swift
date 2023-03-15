//
//  ChangePasswordViewController.swift
//  MKTFU
//
//  Created by mac on 2023-03-13.
//

import UIKit
import Auth0

struct Password: Codable {
    var access_token: String
}

class ChangePasswordViewController: UIViewController, Storyboarded {
    
    //MARK: - Properties
    
    weak var coordinator: MainCoordinator?
    var model: Password?
    
    //MARK: - Outlets
    
    @IBOutlet weak var lpHeaderView: LPHeaderView!
    @IBOutlet weak var oldPasswordView: LpCustomView!
    @IBOutlet weak var newPasswordView: LpCustomView!
    @IBOutlet weak var confirmNewPasswordView: LpCustomView!
    
    //MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make back button useful in custom header view
        lpHeaderView.onBackPressed = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        newPasswordView.lblPasswordSecurityLevel.isHidden = true
        
        
    }
    
    //MARK: - IBAction
    
    @IBAction func updatePasswordBtnPressed(_ sender: UIButton) {
        getManagermrntApiAccessToken()
    }
    
    
    //MARK: - Methods
    
    func getManagermrntApiAccessToken() {
        let headers = ["content-type": "application/x-www-form-urlencoded"]

        let postData = NSMutableData(data: "grant_type=client_credentials".data(using: String.Encoding.utf8)!)
        postData.append("&client_id=1KZC0WwJakXRNiyw15hXTAkG7NiaW64o".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret={yourClientSecret}".data(using: String.Encoding.utf8)!)
        postData.append("&audience=https://dev-p77zu24vjhtaaicl.us.auth0.com/api/v2/".data(using: String.Encoding.utf8)!)

        let request = NSMutableURLRequest(url: NSURL(string: "https://dev-p77zu24vjhtaaicl.us.auth0.com/oauth/token")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse)
          }
        })

        dataTask.resume()
    }
    
    func getUserId() {
        let headers = ["authorization": "Bearer \(Constants.access_token)"]

        let request = NSMutableURLRequest(url: NSURL(string: "https://\(Constants.domain)/api/v2/users?q=email:%22\("marianpliatsko@gmail.com")%22&search_engine=v3")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
              print(httpResponse)
          }
        })

        dataTask.resume()
    }

    func changePassword(password: String) {
        let headers = [
          "content-type": "application/json",
          "authorization": "Bearer {yourMgmtApiAccessToken}"
        ]
        let parameters = [
          "password": password,
          "connection": Constants.connection
        ] as [String : Any]

        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {return}

        let request = NSMutableURLRequest(url: NSURL(string: "https://\(Constants.domain)/api/v2/users/%7BuserId%7D")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "PATCH"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
          if (error != nil) {
            print(error)
          } else {
            let httpResponse = response as? HTTPURLResponse
            print(httpResponse)
          }
        })

        dataTask.resume()
    }

}
