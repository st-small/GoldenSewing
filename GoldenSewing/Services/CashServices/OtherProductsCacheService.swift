//
//  OtherProductsCacheService.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
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

public class OtherProductsCacheService {
    
    public let tag = "OtherProductsCacheService"
    public static let shared = OtherProductsCacheService()
    
    private let api: ApiRequestService
    private let apiQueue: AsyncQueue
    private let realm = try! Realm()
    
    private var categoryId: Int?
    private var category: CategoryModelRealmItem?
    
    //Hooks
    public var onUpdate: Action<OtherProductModel>?
    public var onFail: Trigger?
    public var cache: OtherProductModel?
    
    private init() {
        api = ApiRequestService(area: "pages", type: ProductsCacheService.self)
        apiQueue = AsyncQueue.createForApi(for: tag)
    }
    
    public func load(id: Int) {
        categoryId = id == 1 ? 1148 : 1122
        category = realm.objects(CategoryModelRealmItem.self).filter({ $0.id == id }).first
        loadCached()
    }
    
    public func all() {
        guard let categoryId = categoryId else { return }
        let request = self.api.otherProducts(categoryId: categoryId)
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
        let customId = categoryId == 1148 ? 1 : 18
        let array = realm.objects(OtherProductModelRealmItem.self)
        guard let currentItem = array.filter({ $0.id == customId }).first else { return }
        cache = OtherProductModel(item: currentItem)
    }
    
    private func addOrUpdate(_ product: OtherProductModel) {
        if let productItem = realm.objects(OtherProductModelRealmItem.self).filter({ $0.id == product.id }).first {
            if product.modified != productItem.modified {
                removeItemFromDB(product.id)
                addItemToDB(product)
            } else {
                return
            }
        } else {
            addItemToDB(product)
        }
    }
    
    private func addItemToDB(_ product: OtherProductModel) {
        try! self.realm.write {
            let item = OtherProductModelRealmItem(item: product)
            self.realm.add(item)
        }
        onUpdate?(product)
    }
    
    private func removeItemFromDB(_ productId: Int) {
        try! self.realm.write {
            guard let item = realm.objects(OtherProductModelRealmItem.self).filter({ $0.id == productId }).first else { return }
            realm.delete(item)
        }
    }
}
