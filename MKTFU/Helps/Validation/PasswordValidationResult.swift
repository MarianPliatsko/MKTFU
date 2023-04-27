//
//  PasswordValidationResult.swift
//  MKTFU
//
//  Created by mac on 2023-04-24.
//

import Foundation

enum PasswordValidationResult {
    struct PassedValidationChecks: OptionSet {
        let rawValue: Int
        static let enoughCharacters = PassedValidationChecks(rawValue: 1 << 0)
        static let hasOneUppercase = PassedValidationChecks(rawValue: 1 << 1)
        static let hasOneDigit = PassedValidationChecks(rawValue: 1 << 2)
        static let hasOneSymbol = PassedValidationChecks(rawValue: 1 << 3)
        static var all: PassedValidationChecks = [.enoughCharacters,
                                                  .hasOneUppercase,
                                                  .hasOneDigit,
                                                  .hasOneSymbol]
    }
    case valid
    case invalid(PassedValidationChecks)
}
