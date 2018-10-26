//
//  String+Extension.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 08.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

extension String  {
    var isNumber : Bool {
        get{
            return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
        }
    }
    
    mutating func replace(_ originalString:String, with newString:String) {
        self = self.replacingOccurrences(of: originalString, with: newString)
    }
    
    mutating func replaceWrongCharacters() {
        if self.contains("&#171;") && self.contains("&#187;") {
            self = self.replacingOccurrences(of: "&#171;", with: "«")
            self = self.replacingOccurrences(of: "&#187;", with: "»")
        } 
    }
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self) //according to date format your date string
        //print(date ?? "") //Convert String to Date
        return date!
    }
}
