//
//  ValidateFirstName.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

class ValidateFirstName {
    
    func validateFirstName(name: String) ->Bool {
        // Length be 18 characters max and 3 characters minimum
        let nameRegex = "^\\w{3,18}$"
        let trimmedString = name.trimmingCharacters(in: .whitespaces)
        let validateName = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        let isValidateName = validateName.evaluate(with: trimmedString)
        print("isValidateName: \(isValidateName)")
        return isValidateName
    }
}