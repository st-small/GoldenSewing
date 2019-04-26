//
//  String+Extension.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 08.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

extension String  {
    
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Your date format
        dateFormatter.timeZone = TimeZone.current
        let date = dateFormatter.date(from: self) //according to date format your date string
        //print(date ?? "") //Convert String to Date
        return date!
    }
    
    public static func tag(_ type: Any) -> String {
        
        let type =  String(describing: Swift.type(of: type))
        
        return type.components(separatedBy: ".").first!
    }
    
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: Data(utf8), options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print(error)
            return nil
        }
    }
}
