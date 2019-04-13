//
//  ProductsPresenter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol ProductsViewDelegate { }

public class ProductsPresenter {
    
    public var delegate: ProductsViewDelegate
    
    private var products = [String]()
    private var interactor: ProductsInteractor!
    
    public init(with categoryId: Int, delegate: ProductsViewDelegate) {
        
        self.delegate = delegate
        self.interactor = ProductsInteractor(with: categoryId, delegate: self)
    }
    
    public func categoryTitle() -> String {
        return interactor.categoryTitle()
    }
    
    public func load() {
        interactor.load()
    }
    
    public func goBack() {
        interactor.goBack()
    }
    
    public func countOfProducts() -> Int {
        return products.count
    }
    
    public func productAt(_ index: Int) -> String {
        return products[index]
    }
    
    public func select(_ product: String) {
        
    }
}

extension ProductsPresenter: ProductsPresenterDelegate {
    public func update(with data: [ProductModel]) { }
    public func problemWithRequest() { }
}
