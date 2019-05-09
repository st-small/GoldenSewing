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
    private let service = ProductsCacheService.shared
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
            guard let this = self else { return }
            let array = realm.objects(ProductModelRealmItem.self)
            if let productItem = array.first(where: { $0.id == value }) {
                let item = ProductModel(item: productItem)
                this.delegate.update(item)
            } else {
                
            }
        }
    }
    
    public func handleCellAction(with productId: Int) {
        router.openDetailView(productId: productId)
    }
}
