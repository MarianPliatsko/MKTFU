//
//  Management API.swift
//  MKTFU
//
//  Created by mac on 2023-02-26.
//

import Foundation
import Auth0
import JWTDecode

enum Auth0Error: Error {
    case missingEmail
    case missingPassword
    case error(AuthenticationError)
}

extension Auth0Error: CustomStringConvertible {
    var description: String {
        switch self {
        case .missingEmail:
            return "There is no email. Please provide email adress"
        case .missingPassword:
            return "There is no password. Please provide password"
        case .error(let error):
            return error.localizedDescription
        }
    }
}

extension Auth0Error: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .missingEmail:
            return "Missing Email"
        case .missingPassword:
            return "Missing Password"
        case .error(let error):
            return error.errorDescription ?? error.localizedDescription
        }
    }
}

class Auth0Manager {
    
    //    let audience = "https://\(Auth0Constants.domain)/api/v2/"
    let auth0: Authentication!
    
    static let shared = Auth0Manager()
    
    init() {
        auth0 = Auth0.authentication()
    }
    
    func loginWithEmail(email: String,
                        password: String,
                        complition: @escaping(Result<String?, Auth0Error>) -> Void) {
        if email.isEmpty {
            complition (.failure(.missingEmail))
            return
        }
        
        auth0
            .login(usernameOrEmail: email,
                   password: password,
                   realmOrConnection: Auth0Constants.connection,
                   audience: Auth0Constants.audience,
                   scope: Auth0Constants.scope)
            .start { result in
                switch result {
                case .success(let credentials):
                    complition (.success(credentials.accessToken))
                case .failure(let error):
                    complition (.failure(.error(error)))
                }
                
            }
    }
    
    func createUser(email: String,
                    password: String,
                    connection: String,
                    userMetaData: [String: Any],
                    complition: @escaping(Result<String?, Auth0Error>) -> Void) {
        auth0.signup(email: email,
                     password: password,
                     connection: connection,
                     userMetadata: userMetaData)
        .start { result in
            switch result {
            case .success(let user):
                complition (.success(user.email))
            case .failure(let error):
                complition (.failure(.error(error)))
            }
        }
    }
    
    func getUserID(accessToken: String,
                   complition: @escaping(Result<String?, Auth0Error>) -> Void) {
        auth0
            .userInfo(withAccessToken: accessToken)
            .start { result in
                switch result {
                case .success(let user):
                    complition (.success(user.sub))
                case .failure(let error):
                    complition (.failure(.error(error)))
                }
            }
    }
    
    func resetPassword(_ email: String,
                       complition: @escaping(Result<Any?, Auth0Error>) -> Void) {
        auth0
            .resetPassword(email: email,
                           connection: Auth0Constants.connection)
            .start { result in
                switch result {
                case .success:
                    complition (.success(result))
                case .failure(let error):
                    complition (.failure(.error(error)))
                }
            }
    }
    
    func logOut() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    print ("Session cookie cleared")
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}
