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
    func updateSearchResults(with data: [ProductModel])
    func problemWithRequest()
}

public class ProductsInteractor {
    
    public var delegate: ProductsPresenterDelegate
    private var products = [ProductModel]()
    
    // Services
    private let realm = try! Realm()
    private let service = ProductsCacheService.shared
    private let router = Router.shared
    
    // Tools
    private var apiQueue: AsyncQueue!
    
    // Data
    private var categoryId: Int!
    
    public init(with categoryId: Int, delegate: ProductsPresenterDelegate) {
        
        self.categoryId = categoryId
        self.delegate = delegate
        apiQueue = AsyncQueue.createForApi(for: "ProductsInteractor")
        
        service.load(id: categoryId)
    }
    
    public func load() {
        loadData()
        loadCached()
    }
    
    public func needReload() {
        delegate.update(with: service.cache)
    }
    
    private func loadCached() {
        service.load(id: categoryId)
        let cached = service.cache
        products = cached
        delegate.update(with: cached)
    }
    
    public func categoryTitle() -> String {
        guard
            let id = categoryId,
            let title = realm.objects(CategoryModelRealmItem.self).filter("id == %d", id).first?.title else { return "" }
        return title
    }
    
    private func loadData() {
        service.all()
        service.onUpdate = { [weak self] product in
            guard let this = self else { return }
            this.loadCached()
        }
        
        service.onFail = { [weak self] in
            guard let this = self else { return }
            this.delegate.problemWithRequest()
        }
    }
    
    public func search(with text: String) {
        let text = text.lowercased()
        let data = products.filter { (product) -> Bool in
            if "\(product.id)".contains(text) || product.title.lowercased().contains(text) {
                return true
            }
            
            return false
        }
        
        delegate.updateSearchResults(with: data)
    }
    
    public func handleCellAction(with productId: Int) {
        router.openDetailView(productId: productId)
    }
    
    public func goBack() {
        router.goBack()
    }
}
