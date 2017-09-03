//
//  Date+Extension.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 12.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss" //Your date format
        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let date = dateFormatter.string(from: self as Date) //according to date format your date string
        return date
    }
    
    func toCustomString() -> String {
        let dateFormatter = DateFormatter()
        if !isToday() {
            if !isYesterday() {
                dateFormatter.dateFormat = "dd MMMM в HH:mm"
            } else {
                dateFormatter.dateFormat = "Вчера в HH:mm"
            }
        } else {
            dateFormatter.dateFormat = "Сегодня в HH:mm"
        }
        let date = dateFormatter.string(from: self as Date) //according to date format your date string
        return date
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func isYesterday() -> Bool {
        return Calendar.current.isDateInYesterday(self)
    }
}
