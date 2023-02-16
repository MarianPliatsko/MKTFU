//
//  ValidatePassword.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

class ValidatePassword {
    
    func validatePassword(password: String) -> Bool {
        //Minimum 6 characters at least 1 Alphabet and 1 Number:
        let passRegEx = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[A-Z]).{6,}$"
        let trimmedString = password.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
}
