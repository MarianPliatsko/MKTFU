//
//  CatagoryDataRepository.swift
//  MKTFU
//
//  Created by mac on 2023-02-13.
//

import Foundation

class CategoryDataRepository {
    
    enum NetworkError: Error {
        case categoryNotFound
        case timeOut
    }
    
    func getCityList(url: URL?, completion: @escaping (Result<CategoryContainer, NetworkError>) -> Void){
        
        if let url = url {
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            
            let dataTask = URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil || data == nil {
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    
                    if let data = data {
                        let response = try decoder.decode(CategoryContainer.self, from: data)
                        print(response)
                        DispatchQueue.main.async {
                            completion(.success(response))
                        }
                    }
                }
                catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.categoryNotFound))
                    }
                }
            }
            dataTask.resume()
        }
    }
}
