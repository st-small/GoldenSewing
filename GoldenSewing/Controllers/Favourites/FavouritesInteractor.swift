//
//  FavouritesInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 5/7/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public protocol FavouritesPresenterDelegate {
    func update(_ product: ProductModel?)
}

public class FavouritesInteractor {
    
    public var delegate: FavouritesPresenterDelegate
    
    // Services
    private let service = OneItemCacheService.shared
    private let likeService = LikeService.shared
    private let router = Router.shared
    private let realm = try! Realm()
    
    // Tools
    private var apiQueue: AsyncQueue!
    public init(with delegate: FavouritesPresenterDelegate) {
        
        self.delegate = delegate
        
        apiQueue = AsyncQueue.createForApi(for: "FavouritesInteractor")
    }
    
    public func load() {
        likeService.load()
        let vendors = likeService.cached
        if !vendors.isEmpty {
            getItemsByIds(vendors)
        } else {
            delegate.update(nil)
        }
    }
    
    private func getItemsByIds(_ values: [Int]) {
        values.forEach { [weak self] value in
            service.load(id: value)
            guard let this = self else { return }
            if let item = this.service.cache, item.id == value {
                this.delegate.update(item)
            } else {
                this.service.synchronize()
                this.service.onUpdate = { [weak self] product in
                    guard let this = self else { return }
                    this.delegate.update(product)
                }
            }
        }
    }
    
    public func handleCellAction(with productId: Int) {
        router.openDetailView(productId: productId)
    }
}
