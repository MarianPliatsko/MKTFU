//
//  Functions.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

class Validate {
    
    func validatePassword(password: String) -> PasswordValidationResult {
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

