//
//  CreateUserService.swift
//  MKTFU
//
//  Created by mac on 2023-04-26.
//

import Foundation

class CreateUserService {
    
    private let auth0: Auth0Manager
    private let networkManager: NetworkManager
    
    init(auth0: Auth0Manager, networkManager: NetworkManager) {
        self.auth0 = auth0
        self.networkManager = networkManager
    }
    
    convenience init() {
        self.init(auth0: .shared, networkManager: .shared)
    }
    
    func createUser(user: User, password: String, completion: @escaping(Result<User, Error>) -> Void) {
        
        let userMetaData = ["firstName": user.firstName,
                            "lastName": user.lastName,
                            "email": user.email,
                            "phone": user.phone,
                            "streetAddress": user.address,
                            "city": user.city]
        
        auth0.createUser(email: user.email,
                         password: password,
                         connection: Auth0Constants.connection,
                         userMetaData: userMetaData) { [weak self] result in
            switch result {
            case .success(let newUser):
                self?.getAccessToken(user: user,
                                     email: newUser ?? "",
                                     password: password,
                                     completion: completion)
            case .failure(let error):
                completion (.failure(error))
            }
        }
    }
    
    private func getAccessToken(user: User, email:String, password: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth0.loginWithEmail(email: email,
                             password: password) { [weak self] result in
            switch result {
            case .success(let accessToken):
                self?.getUserID(user: user,
                                accessToken: accessToken,
                                completion: completion)
            case .failure(let error):
                completion (.failure(error))
            }
        }
    }
    
    private func getUserID(user: User, accessToken: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth0.getUserID(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let userID):
                self?.createUserOnBackend(user: user,
                                          userID: userID,
                                          token: accessToken,
                                          result: completion)
            case .failure(let error):
                completion (.failure(error
                                    ))
            }
        }
    }
    
    private func createUserOnBackend(user: User, userID: String, token: String, result: @escaping(Result<User,Error>) -> Void) {
        
        let userData = ["id": userID,
                        "firstName": user.firstName,
                        "lastName": user.lastName,
                        "email": user.email,
                        "phone": user.phone,
                        "address": user.address,
                        "city": user.city]
        
        networkManager.request(endpoint: EndpointConstants.userRegistration,
                               type: User.self,
                               token: token,
                               httpMethod: .post,
                               resultsLimit: nil,
                               parameters: userData,
                               completion: result)
    }
}
