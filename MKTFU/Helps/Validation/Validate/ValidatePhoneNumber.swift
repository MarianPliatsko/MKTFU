//
//  ValidatePhoneNumber.swift
//  MKTFU
//
//  Created by mac on 2023-02-09.
//

import Foundation

class ValidatePhoneNumber {
    
    func validatePhoneNumber(phone: String) -> String {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var numberOfElements = 0
        var result = ""
        let mask = "+X (XXX) XXX-XXXX"
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
//        for _ in 0...result.count {
//            numberOfElements += 1
//        }
//        if numberOfElements == 18 {
//            validate.isValidePhoneNumber = true
//        } else {
//            validate.isValidePhoneNumber = false
//        }
        print(result)
        return result
    }
}
