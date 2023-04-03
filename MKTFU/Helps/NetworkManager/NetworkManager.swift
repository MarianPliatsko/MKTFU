//
//  NetworkManager.swift
//  MKTFU
//
//  Created by mac on 2023-02-26.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case patch = "PATCH"
}

enum NetworkingError: Error {
    case invalidUrl
    case invalidData
    case urlIsMissing
    case notFound
    case badResponse
    case unknown
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = URL(string: "http://mktfy-proof.ca-central-1.elasticbeanstalk.com/")
    
    init() {}
    
    func request<T:Codable>(endpoint: String,
                            type: T.Type,
                            token: String,
                            httpMethod: HTTPMethod,
                            parameters: [String: String]?,
                            complition: @escaping(Result<T, Error>) -> Void) {
        guard let url = self.baseURL else{return complition(.failure(NetworkingError.invalidUrl))}
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint))
        urlRequest.addValue("text/plain", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = httpMethod.rawValue
        
        if parameters != nil {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters!, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            guard let data = data else {return complition(.failure(NetworkingError.invalidData))}
            do {
                let json = try JSONDecoder().decode(type, from: data)
                    complition(.success(json))
            }
            catch {
                complition(.failure(error))
            }
        })
        task.resume()
    }
}
