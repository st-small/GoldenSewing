//
//  ProductsCacheService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

private typealias QueryAction = (request: RequestResult<ProductModel>, type: QueryActionType)

private enum QueryActionType {
    case allItems
    case singleItem
}

public class ProductsCacheService {
    
    public let tag = "ProductsCacheService"
    public static let shared = ProductsCacheService()
    
    private let api: ApiRequestService
    private let apiQueue: AsyncQueue
    private let realm = try! Realm()
    
    private var categoryId: Int?
    private var category: CategoryModelRealmItem?
    
    private var requestsQuery = [QueryAction]()
    private var queryCounter = 0
    private let relevance: Double = 60 * 60 * 24 * 10
    
    //Hooks
    public var onUpdate: Action<ProductModel>?
    public var onFail: Trigger?
    
    private init() {
        
        api = ApiRequestService(area: "posts", type: ProductsCacheService.self)
        apiQueue = AsyncQueue.createForApi(for: tag)
    }
    
    public func load(id: Int) {
        categoryId = id
        category = realm.objects(CategoryModelRealmItem.self).filter({ $0.id == id }).first
        cache.removeAll()
        loadCached()
    }
    
    public var cache = [ProductModel]()
    
    public func all() {
        prepareTask()
    }
    
    private func loadCached() {
        let array = realm.objects(ProductModelRealmItem.self)
        let currentItems = array.filter({ $0.category == self.categoryId })
        cache = currentItems.map({ ProductModel(item: $0) })
    }
    
    private func prepareTask() {
        guard let currentCategory = realm.objects(CategoryModelRealmItem.self).filter({ $0.id == self.categoryId }).first else { return }
        // 1. Проверить, что количество товаров такое же как указано в категории
        guard cache.count == currentCategory.count else {
            prepareLoadQueries()
            return
        }
        updateNonRelevanceItems()
    }
    
    private func prepareLoadQueries() {
        var index = 0
        while index < category?.count ?? 0 {
            let request = self.api.products(categoryId: categoryId!, offset: index)
            let action = QueryAction(request, .allItems)
            requestsQuery.append(action)
            index += 10
        }
        
        iterateQueries()
    }
    
    private func updateNonRelevanceItems() {
        let items = realm.objects(ProductModelRealmItem.self).filter({ $0.category == self.categoryId })
        let needUpdateItems = items.filter({ $0.timestamp + self.relevance < Date().timeIntervalSince1970 })
        let ids = needUpdateItems.map({ $0.id })
        for id in ids {
            let request = api.productBy(id: id)
            let action = QueryAction(request, .singleItem)
            requestsQuery.append(action)
        }
        
        iterateQueries()
    }
    
    private func iterateQueries() {
        queryCounter = 0
        guard !requestsQuery.isEmpty else { return }
        startRequest()
    }
    
    private func startRequest() {
        let action = requestsQuery[0]
        let request = action.request
        requestsQuery.remove(at: 0)
        request.async(apiQueue) { [weak self] (response) in
            
            guard let this = self else { return }
            if response.isSuccess {
                
                guard let product = response.data else { return }
                this.onUpdate?(product)
                this.queryCounter += 1
                
                switch (action.type, this.queryCounter)  {
                case (.allItems, 10):
                    this.iterateQueries()
                case (.singleItem, _):
                    this.iterateQueries()
                default: break
                }
                
                this.addOrUpdate(product)
            }
            
            if response.isFail {
                this.onFail?()
            }
        }
    }
    
    private func addOrUpdate(_ product: ProductModel) {
        let item = realm.objects(ProductModelRealmItem.self).filter({ $0.id == product.id }).first
        if item == nil {
            addItemToDB(product)
        }
        
        guard let itemInDB = item else { return }
        if product.modified > itemInDB.modified || itemInDB.timestamp + relevance < Date().timeIntervalSince1970 {
            removeItemFromDB(product.id)
            addItemToDB(product)
        }
    }
    
    private func addItemToDB(_ product: ProductModel) {
        try! self.realm.write {
            let item = ProductModelRealmItem(item: product)
            self.realm.add(item)
        }
    }
    
    private func removeItemFromDB(_ productId: Int) {
        try! self.realm.write {
            guard let item = realm.objects(ProductModelRealmItem.self).filter({ $0.id == productId }).first else { return }
            realm.delete(item)
        }
    }
}

