//
//  CategoryModel.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Gloss

private let relevance: Double = 60 * 60 * 24 * 5

public class CategoryModel: Glossy {
    
    public var id = 0
    public var title = ""
    public var count = 0
    public var link = ""
    public var timestamp: Double = 0
    public var needUpdate = false
    
    public init(item: CategoryModelRealmItem) {
        self.id = item.id
        self.title = item.title
        self.count = item.count
        self.link = item.link
        self.timestamp = item.timestamp
        self.needUpdate = checkRelevance(item.timestamp)
    }
    
    public required init?(json: JSON) {
        self.id = (Keys.id <~~ json)!
        self.count = (Keys.count <~~ json)!
        
        self.title = (Keys.title <~~ json)!
        self.link = (Keys.link <~~ json) ?? ""
        self.timestamp = Date().timeIntervalSince1970
    }
    
    public func toJSON() -> JSON? {
        return nil
    }
    
    public struct Keys {
        
        public static let id = "id"
        public static let count = "count"
        
        public static let title = "name"
        public static let link = "link"
    }
    
    private func checkRelevance(_ timestamp: Double) -> Bool {
        let currentTimestamp = Date().timeIntervalSince1970
        return (timestamp + relevance) < currentTimestamp
    }
}

public class CategoryModelRealmItem: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var count = 0
    @objc dynamic var link = ""
    @objc dynamic var timestamp: Double = 0
    @objc dynamic var needUpdate = false
    
    public convenience init(item: CategoryModel) {
        self.init()
        
        self.id = item.id
        self.title = item.title
        self.count = item.count
        self.link = item.link
        self.timestamp = item.timestamp
        self.needUpdate = item.needUpdate
    }
}
