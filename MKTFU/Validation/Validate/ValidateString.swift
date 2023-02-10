//
//  ValidateString.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

class ValidateString {
    
    func validateString(regEX: String, password: String) -> Bool {
        let passRegEx = regEX
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
}
