//
//  String.swift
//  ProNexus
//
//  Created by thanh cto on 14/10/2021.
//

import Foundation
import UIKit

// validate form
extension String {
    //email
    func isEmail() -> Bool {
        let __firstpart = "[A-Z0-9a-z]([A-Z0-9a-z._%+-]{0,30}[A-Z0-9a-z])?"
        let __serverpart = "([A-Z0-9a-z]([A-Z0-9a-z-]{0,30}[A-Z0-9a-z])?\\.){1,5}"
        let __emailRegex = "\(__firstpart)@\(__serverpart)[A-Za-z]{2,8}"
        let __emailPredicate = NSPredicate(format: "SELF MATCHES %@", __emailRegex)
        return __emailPredicate.evaluate(with: self)
    }
    //phone
    func isValidPhone() -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: self)
    }
    //number
    func isNumber() -> Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}


//blank
extension String {
    var isBlank: Bool {
        return allSatisfy({ $0.isWhitespace })
    }
}
//blank
extension Optional where Wrapped == String {
    var isBlank: Bool {
        return self?.isBlank ?? true
    }
}
//blank
extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
    
}



// let s = "hello"
// s[0..<3] // "hel"
// s[3...]  // "lo"
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }
    
    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        return String(self[start...])
    }
}


extension String {
    /**
     Takes the current String struct and strips out HTML using regular expression. All tags get stripped out.
     
     :returns: String html text as plain text
     */
    
    var htmlStripped : String {
        return self.stringByDecodingHTMLEntities.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    var convertToKey: String {
        var text = self.lowercased().folding(options: .diacriticInsensitive, locale: .current)
        text = text.replacingOccurrences(of: "đ", with: "d")
        return text
    }
}

private let characterEntities : [ Substring : Character ] = [
    // XML predefined entities:
    "&quot;"    : "\"",
    "&amp;"     : "&",
    "&apos;"    : "'",
    "&lt;"      : "<",
    "&gt;"      : ">",
    
    // HTML character entity references:
    "&nbsp;"    : "\u{00a0}",
    // ...
    "&diams;"   : "♦",
]

extension String {
    
    /// Returns a new string made by replacing in the `String`
    /// all HTML character entity references with the corresponding
    /// character.
    var stringByDecodingHTMLEntities : String {
        
        // ===== Utility functions =====
        
        // Convert the number in the string to the corresponding
        // Unicode character, e.g.
        //    decodeNumeric("64", 10)   --> "@"
        //    decodeNumeric("20ac", 16) --> "€"
        func decodeNumeric(_ string : Substring, base : Int) -> Character? {
            guard let code = UInt32(string, radix: base),
                  let uniScalar = UnicodeScalar(code) else { return nil }
            return Character(uniScalar)
        }
        
        // Decode the HTML character entity to the corresponding
        // Unicode character, return `nil` for invalid input.
        //     decode("&#64;")    --> "@"
        //     decode("&#x20ac;") --> "€"
        //     decode("&lt;")     --> "<"
        //     decode("&foo;")    --> nil
        func decode(_ entity : Substring) -> Character? {
            
            if entity.hasPrefix("&#x") || entity.hasPrefix("&#X") {
                return decodeNumeric(entity.dropFirst(3).dropLast(), base: 16)
            } else if entity.hasPrefix("&#") {
                return decodeNumeric(entity.dropFirst(2).dropLast(), base: 10)
            } else {
                return characterEntities[entity]
            }
        }
        
        // ===== Method starts here =====
        
        var result = ""
        var position = startIndex
        
        // Find the next '&' and copy the characters preceding it to `result`:
        while let ampRange = self[position...].range(of: "&") {
            result.append(contentsOf: self[position ..< ampRange.lowerBound])
            position = ampRange.lowerBound
            
            // Find the next ';' and copy everything from '&' to ';' into `entity`
            guard let semiRange = self[position...].range(of: ";") else {
                // No matching ';'.
                break
            }
            let entity = self[position ..< semiRange.upperBound]
            position = semiRange.upperBound
            
            if let decoded = decode(entity) {
                // Replace by decoded character:
                result.append(decoded)
            } else {
                // Invalid entity, copy verbatim:
                result.append(contentsOf: entity)
            }
        }
        // Copy remaining characters to `result`:
        result.append(contentsOf: self[position...])
        return result
    }
    
}


extension String{
    // đ format
    func convertDoubleToCurrency(symbol: String = "đ") -> String{
        let amount1 = Double(self.trimmingCharacters(in: .whitespacesAndNewlines))
        if let amount1 = amount1 {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            numberFormatter.currencySymbol = symbol
            numberFormatter.locale = Locale(identifier: "vi_VN")
            return numberFormatter.string(from: NSNumber(value: amount1))!
        } else
        {
            return self;
        }
    }
    
    // 100K format
    func convertDoubleToCurrencyK() -> String{
        var amount1 = Double(self)
        if amount1! >= 1000 {
            amount1 = amount1! / 1000
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = "K"
        numberFormatter.locale = Locale(identifier: "vi_VN")
        return numberFormatter.string(from: NSNumber(value: amount1!))!
    }
    
    func formatDecimalInput() -> String{
        print(self.numericString())
        print(self)
        let amount1 = Double(self.numericString())
        if let amount1 = amount1 {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: amount1))!
        } else
        {
            return self;
        }
    }
    
    func formatDecimal() -> String{
        let amount1 = Double(self)
        if let amount1 = amount1 {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            return numberFormatter.string(from: NSNumber(value: amount1))!
        } else
        {
            return self;
        }
    }
    
    static let numberFormatter = NumberFormatter()
    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
    
    var percentValue: Double {
        return self.doubleValue * 0.01
    }
    
    var intValue: Int {
        return Int(self) ?? 0
    }
    
    var numberValue: Double {
        return Double(self.numericString()) ?? 0
    }
    
    func numericString() -> String {
        return self.components(separatedBy:CharacterSet.decimalDigits.inverted)
            .joined()
    }
}
