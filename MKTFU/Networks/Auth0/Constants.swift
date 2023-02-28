//
//  Constants.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation

struct Constants {
    static let connection = "Username-Password-Authentication"
    static let domain = "dev-p77zu24vjhtaaicl.us.auth0.com"
    static let clientId = "1KZC0WwJakXRNiyw15hXTAkG7NiaW64o"
    static let scope = "openid profile"
}


//guard let jwt = try? decode(jwt: credentials.idToken),
//      let name = jwt["name"].string,
//      let picture = jwt["picture"].string,
//      let accessToken = try? decode(jwt: credentials.accessToken) else {return}
//print("Name: \(name)")
//print("Picture URL: \(picture)")
//print("Id token: \(jwt)")
//print("Access Token: \(accessToken)")
//break


/*
 class ManagementAPI {
     
     static let shared = ManagementAPI()
     
     init() {}
     
     func request(token: String, complition: @escaping(Result<HTTPURLResponse, Error>) -> Void) {
         
         let headers = [
           "content-type": "application/json",
           "authorization": "Bearer \(token)"
         ]
         let parameters = [
           "password": "newPassword",
           "connection": "connectionName"
         ] as [String : Any]

         let postData = try! JSONSerialization.data(withJSONObject: parameters, options: [])

         let request = NSMutableURLRequest(url: NSURL(string: "https://dev-p77zu24vjhtaaicl.us.auth0.com/api/v2/users/%7BuserId%7D")! as URL,
                                                 cachePolicy: .useProtocolCachePolicy,
                                             timeoutInterval: 10.0)
         request.httpMethod = "PATCH"
         request.allHTTPHeaderFields = headers
         request.httpBody = postData as Data

         let session = URLSession.shared
         let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
             if let error = error {
                 complition(.failure(error))
             }
             do {
             let httpResponse = response as? HTTPURLResponse
                 complition(.success(httpResponse!))
           }
         })

         dataTask.resume()
     }
 }

 
 */
