//
//  ProductsInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public protocol ProductsPresenterDelegate {
    func update(with data: [ProductModel])
    func problemWithRequest()
}

public class ProductsInteractor {
    
    public var delegate: ProductsPresenterDelegate
    private var products = [ProductModel]()
    
    
    // Services
    private let realm = try! Realm()
    private let service: ProductsCacheService
    
    // Tools
    private var apiQueue: AsyncQueue!
    
    // Data
    private var categoryId: Int!
    
    public init(with categoryId: Int, delegate: ProductsPresenterDelegate) {
        
        self.categoryId = categoryId
        self.delegate = delegate
        apiQueue = AsyncQueue.createForApi(for: "ProductsInteractor")
        service = ProductsCacheService(id: categoryId)
    }
    
    public func load() {
        loadData()
        
        service.load()
        let cached = service.cache
        delegate.update(with: cached)
    }
    
    public func categoryTitle() -> String {
        guard let title = realm.objects(CategoryModelRealmItem.self).filter("id == %d", categoryId).first?.title else { return "" }
        return title
    }
    
    private func loadData() {
        service.all()
        service.onUpdate = { products in
            
        }
        
//        let request = service.all()
//        request.async(apiQueue) { (response) in
//
//            DispatchQueue.main.async { [weak self] in
//
//                guard let this = self else { return }
//                if response.isFail {
//                    this.delegate.problemWithRequest()
//                    return
//                }
//
//
//            }
//        }
    }
    
    public func goBack() {
        let router = Router.shared
        router.goBack()
    }
}
