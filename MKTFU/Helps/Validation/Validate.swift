//
//  Functions.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

extension String {
    func validate(regEX: String) -> Bool {
        let passRegEx = regEX
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
}

enum PasswordValidationResult {
    struct PassedValidationChecks: OptionSet {
        let rawValue: Int
        static let enoughCharacters = PassedValidationChecks(rawValue: 1 << 0)
        static let hasOneUppercase = PassedValidationChecks(rawValue: 1 << 1)
        static let hasOneDigit = PassedValidationChecks(rawValue: 1 << 2)
        static let hasOneSymbol   = PassedValidationChecks(rawValue: 1 << 3)
        static var all: PassedValidationChecks = [.enoughCharacters,
                                                  .hasOneUppercase,
                                                  .hasOneDigit,
                                                  .hasOneDigit]
    }
    case valid
    case invalid(PassedValidationChecks)
}


class Validate {
    
    let validateString = ValidateString()
    let validateFirstName = ValidateFirstName()
    let validateLastName = ValidateLastName()
    let validatePassword = ValidatePassword()
    let validatePhoneNumber = ValidatePhoneNumber()
    let validateEmail = ValidateEmail()
    let validateVerificationCode = ValidateVerificationCode()
    
    func validate(password: String) -> PasswordValidationResult {
        var passedValidationChecks = PasswordValidationResult.PassedValidationChecks()
        if password.count >= 6 {
            passedValidationChecks.insert(.enoughCharacters)
        }
        if password.validate(regEX: ".*[A-Z]+.*") {
            passedValidationChecks.insert(.hasOneUppercase)
        }
        if password.validate(regEX: ".*[0-9]+.*") {
            passedValidationChecks.insert(.hasOneDigit)
        }
        if password.validate(regEX: ".*[$@$#!%*?&]+.*") {
            passedValidationChecks.insert(.hasOneSymbol)
        }
        if passedValidationChecks == .all {
            return .valid
        }
        return .invalid(passedValidationChecks)
    }
}

