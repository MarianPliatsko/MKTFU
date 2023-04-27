//
//  DateFormatter+.swift
//  MKTFU
//
//  Created by mac on 2023-04-08.
//

import Foundation

extension String {
    func formatDate(from format: String, to newFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else { return self }
        dateFormatter.dateFormat = newFormat
        return dateFormatter.string(from: date)
    }
    
    func removeHtmlTagsFromUrlEncodedString() -> String? {
        let encodedData = self.data(using: .utf8)!
        let attributedString = try? NSAttributedString(data: encodedData, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        let regex = try! NSRegularExpression(pattern: "<.*?>", options: .caseInsensitive)
        let range = NSMakeRange(0, attributedString?.string.count ?? 0)
        let plainString = regex.stringByReplacingMatches(in: attributedString?.string ?? "", options: [], range: range, withTemplate: "")
        return plainString
    }
    
    func validate(regEX: String) -> Bool {
        let passRegEx = regEX
        let trimmedString = self.trimmingCharacters(in: .whitespaces)
        let validatePassord = NSPredicate(format:"SELF MATCHES %@", passRegEx)
        let isvalidatePass = validatePassord.evaluate(with: trimmedString)
        return isvalidatePass
    }
    
    func validatePhoneNumber() -> String {
        let numbers = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        let mask = "+X (XXX) XXX-XXXX"
        var index = numbers.startIndex
        
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
            } else {
                result.append(ch)
            }
        }
        return result
    }
}

