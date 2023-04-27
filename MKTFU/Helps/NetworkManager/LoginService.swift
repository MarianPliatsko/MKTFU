//
//  LoginService.swift
//  MKTFU
//
//  Created by mac on 2023-04-25.
//

import Foundation
import Auth0
import JWTDecode
import KeychainSwift

enum LoginServiceError: Error {
    case invalidUserID
}

class LoginService {
    private let networkManager: NetworkManager
    private let auth0: Auth0Manager
    private let keyChain: KeychainSwift
    
    init(networkManager: NetworkManager, auth0: Auth0Manager, keyChain: KeychainSwift) {
        self.networkManager = networkManager
        self.auth0 = auth0
        self.keyChain = keyChain
    }
    
    convenience init() {
        self.init(networkManager: .shared, auth0: .shared, keyChain: .init())
    }
    
    func login(email: String, password: String, completion: @escaping(Result<User,Error>) -> Void) {
        auth0.loginWithEmail(email: email, password: password) { [weak self] result in
            switch result {
            case .success(let accessToken):
                    self?.keyChain.set(accessToken, forKey: KeychainConstants.accessTokenKey)
                    print("Access Token: \(String(describing: accessToken))")
                    self?.keyChain.set(password, forKey: KeychainConstants.passwordKey)
                self?.getUserID(accessToken: accessToken,
                                completion: completion)
            case .failure(let error):
                completion (.failure(error))
            }
        }
    }
    
    private func getUserID(accessToken: String, completion: @escaping(Result<User,Error>) -> Void) {
        auth0.getUserID(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let userID):
                guard let encodedUserId = userID.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
                    completion (.failure(LoginServiceError.invalidUserID))
                    return
                }
                self?.keyChain.set(userID, forKey: KeychainConstants.userIDKey)
                self?.keyChain.set(encodedUserId, forKey: KeychainConstants.encodedUserIDKey)
                self?.keyChain.set(accessToken, forKey: KeychainConstants.accessTokenKey)
                print("Encoded User id: \(encodedUserId)")
                self?.getUserCredential(token: accessToken, userID: userID, result: completion)
            case .failure(let error):
                completion (.failure(error))
            }
        }
    }
    
    private func getUserCredential(token: String, userID: String, result: @escaping(Result<User,Error>) -> Void) {
        networkManager.request(endpoint: "\(EndpointConstants.getUserProfile)\(userID)",
                               type: User.self,
                               token: token,
                               httpMethod: .get,
                               resultsLimit: nil,
                               parameters: nil,
                               completion: result)
    }
}
