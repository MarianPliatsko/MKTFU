//
//  ValidateVerificationCode.swift
//  MKTFU
//
//  Created by mac on 2023-02-28.
//

import Foundation

class ValidateVerificationCode {
    
    func validateVerificationCode(code: String) -> String {
        let code = code.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        let mask = "XX - XX - XX"
        var index = code.startIndex

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < code.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(code[index])

                // move numbers iterator to the next index
                index = code.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        print(result)
        return result
    }
}
