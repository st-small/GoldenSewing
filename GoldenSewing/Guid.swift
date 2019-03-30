//
//  Guid.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public class Guid {
    
    public static var new: String {
        return UUID().uuidString
    }
}
