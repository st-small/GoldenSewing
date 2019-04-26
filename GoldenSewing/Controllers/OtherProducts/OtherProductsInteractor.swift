//
//  OtherProductsInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public protocol OtherProductsPresenterDelegate {
    func update(with data: OtherProductModel)
    func problemWithRequest()
}

public class OtherProductsInteractor {
    
    public var delegate: OtherProductsPresenterDelegate
    private var products: OtherProductModel?
    
    // Services
    private let realm = try! Realm()
    private let service = OtherProductsCacheService.shared
    
    // Tools
    private var apiQueue: AsyncQueue!
    
    // Data
    private var categoryId: Int!
    
    public init(with categoryId: Int, delegate: OtherProductsPresenterDelegate) {
        
        self.categoryId = categoryId
        self.delegate = delegate
        apiQueue = AsyncQueue.createForApi(for: "OtherProductsInteractor")
        
        service.load(id: categoryId)
    }
    
    public func load() {
        loadData()
        loadCached()
    }
    
    private func loadCached() {
        service.load(id: categoryId)
        let cached = service.cache
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
            this.delegate.update(with: product)
        }
        
        service.onFail = { [weak self] in
            guard let this = self else { return }
            this.delegate.problemWithRequest()
        }
    }
    
    public func getDescription() -> String {
        switch categoryId {
        case 1:
            return Constants.DescriptionText.others.textValue
        case 18:
            return Constants.DescriptionText.heraldry.textValue
        default:
            return ""
        }
    }
    
    public func goBack() {
        let router = Router.shared
        router.goBack()
    }
}
