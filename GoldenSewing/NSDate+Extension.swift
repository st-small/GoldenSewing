//
//  NSDate+Extension.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 12.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

extension NSDate {
    
    static func <= (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.timeIntervalSince1970 <= rhs.timeIntervalSince1970
    }
    static func >= (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.timeIntervalSince1970 >= rhs.timeIntervalSince1970
    }
    static func > (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.timeIntervalSince1970 > rhs.timeIntervalSince1970
    }
    static func < (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.timeIntervalSince1970 < rhs.timeIntervalSince1970
    }
    static func == (lhs: NSDate, rhs: NSDate) -> Bool {
        return lhs.timeIntervalSince1970 == rhs.timeIntervalSince1970
    }
}
