//
//  OneItemCacheService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/17/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import Gloss
import RealmSwift

public class OneItemCacheService {
    
    public let tag = "OneItemCacheService"
    public static let shared = OneItemCacheService()
    
    private let api: ApiRequestService
    private let apiQueue: AsyncQueue
    private let realm = try! Realm()
    
    private var productId: Int?
    private var product: ProductModelRealmItem?
    
    //Hooks
    public var onUpdate: Action<ProductModel>?
    public var onFail: Trigger?
    
    private init() {
        
        api = ApiRequestService(area: "posts", type: ProductsCacheService.self)
        apiQueue = AsyncQueue.createForApi(for: tag)
    }
    
    public func load(id: Int) {
        productId = id
        let objects = realm.objects(ProductModelRealmItem.self).filter({ $0.id == id })
        if !objects.isEmpty {
            product = objects.first
        }
        
        loadCached()
    }
    
    public var cache: ProductModel?
    
    public func synchronize() {
        guard let id = productId else { return }
        let request = api.productBy(id: id)
        request.async(apiQueue) { [weak self] (response) in
            
            guard let this = self else { return }
            if response.isSuccess {
                
                guard let product = response.data else { return }
                this.onUpdate?(product)
                this.addOrUpdate(product)
            }
            
            if response.isFail {
                this.onFail?()
            }
        }
    }
    
    private func loadCached() {
        let array = realm.objects(ProductModelRealmItem.self)
        guard let currentItem = array.filter({ $0.id == self.productId }).first else { return }
        cache = ProductModel(item: currentItem)
    }
    
    private func addOrUpdate(_ product: ProductModel) {
        let item = realm.objects(ProductModelRealmItem.self).filter({ $0.id == product.id }).first
        if item == nil {
            addItemToDB(product)
        }
        
        guard let itemInDB = item else { return }
        if product.modified > itemInDB.modified {
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

