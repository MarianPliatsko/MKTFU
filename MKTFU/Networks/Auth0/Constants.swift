//
//  Constants.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation

struct Constants {
    static let connection = "Username-Password-Authentication"
    static let domain = "dev-imv7dvp8n7sd2xfz.us.auth0.com"
    static let clientId = "ltUX35Jf2Y3fDA5UdVqodjlkKrLK0soX"
    static let scope = "openid profile"
    static let clientSecret = "kdAhVxXDka-4QvIisER--PkWIrL8ehucXymPiaXRchIW90EI7yrmGOLzc3wB-8mQ"
//    static let access_token = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6ImVNbmZwanVHbG1qemp6R1RHUEIzRCJ9.eyJpc3MiOiJodHRwczovL2Rldi1wNzd6dTI0dmpodGFhaWNsLnVzLmF1dGgwLmNvbS8iLCJzdWIiOiJhdXRoMHw2M2ZlMmI1ZTM5MDNjNWNjMzg3NjA2NGEiLCJhdWQiOlsiaHR0cHM6Ly9kZXYtcDc3enUyNHZqaHRhYWljbC51cy5hdXRoMC5jb20vYXBpL3YyLyIsImh0dHBzOi8vZGV2LXA3N3p1MjR2amh0YWFpY2wudXMuYXV0aDAuY29tL3VzZXJpbmZvIl0sImlhdCI6MTY3ODg1NjgyMCwiZXhwIjoxNjc4OTQzMjIwLCJhenAiOiIxS1pDMFd3SmFrWFJOaXl3MTVoWFRBa0c3TmlhVzY0byIsInNjb3BlIjoib3BlbmlkIHByb2ZpbGUgcmVhZDpjdXJyZW50X3VzZXIgdXBkYXRlOmN1cnJlbnRfdXNlcl9tZXRhZGF0YSBkZWxldGU6Y3VycmVudF91c2VyX21ldGFkYXRhIGNyZWF0ZTpjdXJyZW50X3VzZXJfbWV0YWRhdGEgY3JlYXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgZGVsZXRlOmN1cnJlbnRfdXNlcl9kZXZpY2VfY3JlZGVudGlhbHMgdXBkYXRlOmN1cnJlbnRfdXNlcl9pZGVudGl0aWVzIiwiZ3R5IjoicGFzc3dvcmQifQ.e6Bg3YIQaKTh1HaUl8RHxcfleTnwaRRyXSoc1hkvFJNIrbuFRChups4CGNpJJzJENe0CYBLZjZhOByZHYl_XMJSkAS1LvVYn9P0_Xkvd6lyobrRHeNiXWwfFkMBR3LauPdH5Asj7bLHCKy-QC3tHnAfFp9Gsx1hIvkJgD0RJ-juxiHc0rp2BIeHR1haIIhiQ_VJCmdUNHbqzSyc89RpoIjn_WjoNF9AW7lgJBqaPDImTcxnxIckifs5v4vKeDqbd82AeApxpHcudgMax71mS83HKffmiaBWQ5J339-5xpICbZekAtZ1b5CteOfuJ6Q8XjjUxflFPJJZIeQkn249Cww"
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
