//
//  IIdentified.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol IIdentified {
    
    var id: Int { get }
}
extension Array where Element: IIdentified {
    
    public func find(id: Int) -> Element? {
        return self.find({ $0.id == id })
    }
}
