//
//  ProductDetailInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/17/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public protocol ProductDetailPresenterDelegate {
    func update(with data: ProductModel)
    func problemWithRequest()
}

public class ProductDetailInteractor {
    
    public var delegate: ProductDetailPresenterDelegate
    
    // Services
    private let realm = try! Realm()
    private let service = OneItemCacheService.shared
    private let router = Router.shared
    
    // Tools
    private var apiQueue: AsyncQueue!
    
    // Data
    private var productId: Int!
    private var product: ProductModel
    
    public init(with productId: Int, delegate: ProductDetailPresenterDelegate) {
        
        self.productId = productId
        self.delegate = delegate
        apiQueue = AsyncQueue.createForApi(for: "ProductDetailInteractor")
        product = ProductModel()
        
        service.load(id: productId)
    }
    
    public func load() {
        loadData()
        loadCached()
    }
    
    private func loadCached() {
        service.load(id: productId)
        product = service.cache
        delegate.update(with: product)
    }
    
    private func loadData() {
        service.synchronize()
        service.onUpdate = { [weak self] product in
            guard let this = self else { return }
            this.loadCached()
        }
        
        service.onFail = { [weak self] in
            guard let this = self else { return }
            this.delegate.problemWithRequest()
        }
    }
    
    public func productTitle() -> String {
        guard let product = realm.objects(ProductModelRealmItem.self).filter("id == %d", productId).first else { return "" }
        return "\(product.title), \(product.id)"
    }
    
    public func showImagePreview(with transitionDelegate: UIViewControllerTransitioningDelegate) {
        router.showImagePreview(productId, with: transitionDelegate)
    }
    
    public func goBack() {
        router.goBack()
    }
}
