//
//  CategoriesInteractor.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import RealmSwift

public protocol CategoriesPresenterDelegate { 
    
    func update(with data: [CategoryModel])
    func problemWithRequest()
}

public class CategoriesInteractor {
    
    public var delegate: CategoriesPresenterDelegate
    private var categories = [CategoryModel]()
    
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
        
        service.load()
        let cached = service.cache
        delegate.update(with: cached)
    }
    
    private func loadData() {
        
        let request = service.all()
        request.async(apiQueue, completion: { (response) in
            
            DispatchQueue.main.async { [weak self] in
                
                guard let this = self else {
                    return
                }
                
                if (response.isFail) {
                    this.delegate.problemWithRequest()
                    return
                }
                
                guard let category = response.data else { return }
                this.categories.append(category)
                this.delegate.update(with: this.categories)
            }
            
        })
    }
    
    public func toCategory(_ id: Int) {
        let router = Router.shared
        router.openProductsWithCategory(id)
    }
}