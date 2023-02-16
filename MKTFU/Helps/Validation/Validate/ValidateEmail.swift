//
//  ValidateEmail.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

class ValidateEmail {
    
    func validateEmailId(emailID: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let trimmedString = emailID.trimmingCharacters(in: .whitespaces)
        let validateEmail = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let isValidateEmail = validateEmail.evaluate(with: trimmedString)
        print("isValidateEmail:\(isValidateEmail)")
        return isValidateEmail
    }
}
