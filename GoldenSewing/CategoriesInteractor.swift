//
//  CategoriesInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol CategoriesPresenterDelegate { 
    
    func update(with data: [String])
    
    func problemWithRequest()
}

public class CategoriesInteractor {
    
    public var delegate: CategoriesPresenterDelegate
    
    // Services
    
    // Tools
    
    public init(with delegate: CategoriesPresenterDelegate) {
        
        self.delegate = delegate
    }
    
    public func load() { }
    public func updateFromCache() { }
    public func toCategory(_ id: Int) { }
}
