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
    
    let audience = "https://\(Constants.domain)/api/v2/"
    let auth0: Authentication!
    
    static let shared = Auth0Manager()
    
    init() {
        auth0 = Auth0.authentication()
    }
    
    func loginWithEmail(_ email: String, password: String, complition: @escaping(Result<String?, Auth0Error>) -> Void) {
        if email.isEmpty {
            complition (.failure(.missingEmail))
            return
        }
        auth0.login(usernameOrEmail: email,
                    password: password,
                    realmOrConnection: Constants.connection,
                    audience: "https://\(Constants.domain)/api/v2/",
                    scope: Constants.scope)
        .start { result in
            switch result {
            case .success(let credentials):
                complition (.success(credentials.accessToken))
            case .failure(let error):
                complition (.failure(.error(error)))
            }
            
        }
    }
}
