//
//  CacheAdapter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

open class CacheAdapter<TElement> where TElement: ICached {
    
    private let blockQueue: DispatchQueue
    private var queue: AsyncQueue {
        return AsyncQueue.custom(blockQueue)
    }
    
    public var extender: CacheAdapterExtender<TElement>!
    private let tag: String
    
    private let realm = try! Realm() 
    
    public var data = [CacheContainer]()
    private var liveTime: TimeInterval
    private var freshTime: TimeInterval
    public var needSaveFreshDate: Bool = false
    
    public init(tag: String) {
        
        self.tag = "\(tag)::CacheAdapter"
        self.freshTime = 0
        self.liveTime = 0
        
        self.blockQueue = DispatchQueue(label: "\(tag)-\(Guid.new)")
        self.extender = CacheAdapterExtender(for: self)
    }
    
    public convenience init(tag: String, livetime: TimeInterval, freshtime: TimeInterval = 0, needSaveFreshDate: Bool = false) {
        self.init(tag: tag)
        
        self.liveTime = livetime
        self.freshTime = freshtime
        self.needSaveFreshDate = needSaveFreshDate
    }
    
    public func loadCached() {
        blockQueue.sync {
            if let loaded = self.load() {
                self.data = loaded
            }
        }
    }
    
    public var hasData: Bool {
        return 0 != data.count
    }
    
    public var isEmpty: Bool {
        return !hasData
    }
    
    public func addOrUpdate(_ element: CategoryModel) {
        blockQueue.sync {
            let container = CacheContainer(data: element, livetime: liveTime, freshtime: freshTime)
            self.data.append(container)
        }
        save()
    }
    
    private func load() -> [CacheContainer]? {
//        let containers = realm.objects(CacheContainerRealmItem.self)
//        var array = [CacheContainer]()
//        containers.forEach{ array.append(CacheContainer(realmItem: $0)) }
        return nil
    }
    
    public func clearOldCached() {
        
        var ids = [Int]()
        blockQueue.sync {
            
            for element in data {
                if (!element.isRelevance) {
                    ids.append(element.id)
                }
            }
        }
        if (ids.isFilled) {
            clear(ids)
        }
    }
    
    public func clear(_ ids: [Int]) {
//        blockQueue.sync {
//            let items = realm.objects(CacheContainerRealmItem.self).filter("id IN %@", ids)
//            try! realm.write {
//                realm.delete(items)
//            }
//        }
//        save()
    }
    
    private func save() {
//        try! self.realm.write {
//            guard !self.data.isEmpty, let id = self.data.last?.id else { return }
//            let items = self.realm.objects(CacheContainerRealmItem.self).filter("id == %@", id)
//            guard items.isEmpty else { return }
//            let container = CacheContainerRealmItem(item: self.data.last!)
//            self.realm.add(container)
//        }
    }
}
