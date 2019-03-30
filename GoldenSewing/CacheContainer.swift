//
//  CacheContainer.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import Gloss

public class CacheContainer {

    public var id: Int = 0
    public var data = CategoryModel(json: JSON())
    public var relevanceDate: Date
    public var freshDate: Date
    
    public var isRelevance: Bool {
        return 0 < relevanceDate.timeIntervalSince(Date())
    }
    public var isFresh: Bool {
        return 0 < freshDate.timeIntervalSince(Date())
    }
    
    public required init(data: CategoryModel, livetime: TimeInterval, freshtime: TimeInterval) {
        self.id = data.id
        self.data = data
        self.relevanceDate = Date().addingTimeInterval(livetime)
        self.freshDate = Date().addingTimeInterval(freshtime)
    }
    
//    public required init(realmItem: CacheContainerRealmItem) {
//        self.id = realmItem.id
//        self.data = realmItem.data!
//        self.relevanceDate = realmItem.relevanceDate!
//        self.freshDate = realmItem.freshDate!
//    }
    
//    func incrementID() -> Int {
//        let realm = try! Realm()
//        return (realm.objects(CacheContainerRealmItem.self).max(ofProperty: "id") as Int? ?? 0) + 1
//    }
}

//public class CacheContainerRealmItem: Object {
//
//    @objc dynamic var id: Int = 0
//    @objc dynamic var data: CategoryModel?
//    @objc dynamic var relevanceDate: Date?
//    @objc dynamic var freshDate: Date?
//
//    public convenience init(item: CacheContainer) {
//        self.init()
//
//        self.id = item.id
//        self.data = item.data
//        self.relevanceDate = item.relevanceDate
//        self.freshDate = item.freshDate
//    }
//}


