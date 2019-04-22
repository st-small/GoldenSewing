//
//  CategoriesCacheService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/25/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

public class CategoriesCacheService {
    
    public let tag = "CategoriesCacheService"
    
    private let api: ApiRequestService
    private let apiQueue: AsyncQueue
    private let realm = try! Realm()
    
    public init() {
        
        api = ApiRequestService(area: "categories", type: CategoriesCacheService.self)
        apiQueue = AsyncQueue.createForApi(for: tag)
    }
    
    public func load() {
        loadCached()
    }
    
    public var cache = [CategoryModel]()
    
    public func all() -> RequestResult<CategoryModel> {
        
        return RequestResult<CategoryModel> { handler in
            
            let request = self.api.allCategories()
            request.async(self.apiQueue) { response in
                
                if (response.isSuccess) {
                    self.addOrUpdate(response.data!)
                }
                
                handler(response)
            }
        }
    }
    
    private func addOrUpdate(_ category: CategoryModel) {
        try! self.realm.write {
            let item = CategoryModelRealmItem(item: category)
            self.realm.add(item)
        }
        
        clearOldCached()
    }
    
    private func loadCached() {
        let array = realm.objects(CategoryModelRealmItem.self)
        cache = array.map({ CategoryModel(item: $0) })
        
        let heraldry = cache.filter({ $0.id == 18 })
        if !cache.isEmpty && heraldry.isEmpty {
            addHeraldry()
        }
    }
    
    private func addHeraldry() {
        let json = ["id": 18, "count": 0, "name": "Геральдика"] as [String : Any]
        guard let category = CategoryModel(json: json) else { return }
        cache.append(category)
        try! self.realm.write {
            let item = CategoryModelRealmItem(item: category)
            self.realm.add(item)
        }
    }
    
    private func clearOldCached() {
        // check false relevance
        let allItems = self.realm.objects(CategoryModelRealmItem.self)
        let needUpdateItems = allItems.filter { $0.needUpdate == true }
        
        // check duplicates
        var toRemove = [CategoryModelRealmItem]()
        
        allItems.forEach { (item) in
            let items = allItems.filter({ $0.id == item.id }).sorted{ $0.timestamp < $1.timestamp }
            if items.count > 1 {
                toRemove.append(contentsOf: items.dropLast())
            }
        }
        
        try! self.realm.write {
            realm.delete(needUpdateItems + toRemove)
        }
    }
}
