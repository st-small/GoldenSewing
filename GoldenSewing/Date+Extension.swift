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
}
