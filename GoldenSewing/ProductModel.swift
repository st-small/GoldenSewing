//
//  ProductModel.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Gloss

public class ProductModel: Glossy {
    
    public var id = 0
    public var title = ""
    public var timestamp: Double = 0
    
    public var category = 0
    public var modified: Double = 0
    
    public init(item: ProductModelRealmItem) {
        self.id = item.id
        self.title = item.title
        self.timestamp = item.timestamp
        
        self.category = item.category
        self.modified = item.modified
    }
    
    public required init?(json: JSON) {
        self.id = (Keys.id <~~ json)!
        let titleDict: [String: Any] = (Keys.title <~~ json)!
        self.title = (Keys.rendered <~~ titleDict)!
        self.timestamp = Date().timeIntervalSince1970
        
        let categories: [Int] = (Keys.categories <~~ json)!
        self.category = categories.first ?? 0
        
        let modifiedDateString: String = (Keys.modified <~~ json)!
        let modifiedDate = modifiedDateString.toDate()
        self.modified = modifiedDate.timeIntervalSince1970
    }
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public struct Keys {
        
        public static let id = "id"
        public static let title = "title"
        public static let rendered = "rendered"
        public static let categories = "categories"
        
        public static let modified = "modified_gmt"
    }
}

public class ProductModelRealmItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var timestamp: Double = 0
    
    @objc dynamic var category = 0
    @objc dynamic var modified: Double = 0
    
    public convenience init(item: ProductModel) {
        self.init()
        
        self.id = item.id
        self.title = item.title
        self.timestamp = item.timestamp
        
        self.category = item.category
        self.modified = item.modified
    }
}
