//
//  CategoriesInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public protocol CategoriesPresenterDelegate: class {
    
    func update(with data: [CategoryModel])
    func problemWithRequest()
}

public class CategoriesInteractor {
    
    public weak var delegate: CategoriesPresenterDelegate?
    
    // Services
    private let service = CategoriesCacheService()
    
    // Tools
    private var apiQueue: AsyncQueue!
    public init(with delegate: CategoriesPresenterDelegate) {
        
        self.delegate = delegate
        
        apiQueue = AsyncQueue.createForApi(for: "CategoriesInteractor")
    }
    
    public func load() {
        loadData()
        loadCached()
    }
    
    public func needReload() {
        delegate?.update(with: service.cache)
    }
    
    private func loadCached() {
        service.load()
        let cached = service.cache
        delegate?.update(with: cached)
    }
    
    private func loadData() {
        
        let request = service.all()
        request.async(apiQueue, completion: { (response) in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let this = self else {
                    return
                }
    
                if (response.isFail) {
                    this.delegate?.problemWithRequest()
                    return
                }
                
                this.loadCached()
            }
            
        })
    }
    
    public func toCategory(_ id: Int) {
        let router = Router.shared
        router.openProductsWithCategory(id)
    }
}
