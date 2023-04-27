//
//  NetworkManager.swift
//  MKTFU
//
//  Created by mac on 2023-02-26.
//

import Foundation
import UIKit
import Kingfisher

class NetworkManager {
    
    static let shared = NetworkManager()
    private let baseURL = URL(string: "http://mktfy-proof.ca-central-1.elasticbeanstalk.com/")
    
    init() {}
    
    func request<T:Codable>(endpoint: String,
                            type: T.Type,
                            token: String,
                            httpMethod: HTTPMethod,
                            resultsLimit: Int?,
                            parameters: [String: Any]?,
                            completion: @escaping(Result<T, Error>) -> Void) {
        guard var url = self.baseURL else{return completion(.failure(NetworkingError.invalidUrl))}
        let resultsLimit = URLQueryItem(name: "maxResults", value: "\(resultsLimit ?? 100)")
        url.append(queryItems: [resultsLimit])
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(endpoint))
        urlRequest.addValue("text/plain", forHTTPHeaderField: "accept")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        urlRequest.httpMethod = httpMethod.rawValue
        
        if let parameters = parameters {
            urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        }
        
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: {data, response, error in
            var data = data
            if data?.isEmpty == true {
                data = "{}".data(using: .utf8)
            }
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion (.failure(NetworkingError.unknown))
                return
            }
            guard let data = data else {return completion(.failure(NetworkingError.invalidData))}
            do {
                
                let jsonDecode = try JSONDecoder().decode(type, from: data)
                completion(.success(jsonDecode))
            }
            catch {
                completion(.failure(error))
            }
        })
        task.resume()
    }
    
    func getImageId<T:Codable>(for image: UIImage,
                               token: String,
                               type: T.Type,
                               endpoint: String,
                               complition: @escaping (Result<T, Error>) -> Void) {
        guard let url = self.baseURL else{return complition(.failure(NetworkingError.invalidUrl))}
        guard let imageData = image.jpegData(compressionQuality: 0.2) else {
            print("Error converting image to JPEG data")
            return
        }
        var request = URLRequest(url: url.appendingPathComponent(endpoint))
        request.httpMethod = "POST"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        let task = URLSession.shared.uploadTask(with: request, from: body) { data, response, error in
            guard let data = data else {return complition(.failure(NetworkingError.invalidData))}
            do {
                let json = try JSONDecoder().decode(type, from: data)
                complition(.success(json))
            }
            catch {
                complition(.failure(error))
            }
        }
        task.resume()
    }
    
    func getImage(from urlString: String, imageView: UIImageView, complition: @escaping (Result<UIImageView?,Error>) -> Void) {
        let url = URL(string: urlString)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                complition (.success(UIImageView(image: value.image)))
            case .failure(let error):
                complition (.failure(error))
            }
        }
    }
}
