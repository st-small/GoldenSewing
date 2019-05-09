//
//  FavouritesPresenter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 5/7/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol FavouritesViewDelegate {
    func updateEmtyStubState(_ isShow: Bool)
    func updateUI()
}

public class FavouritesPresenter {
    
    public var delegate: FavouritesViewDelegate
    private var interactor: FavouritesInteractor!
    
    // Data
    private var products = [ProductModel]()
    
    public init(with delegate: FavouritesViewDelegate) {
        
        self.delegate = delegate
        self.interactor = FavouritesInteractor(with: self)
    }
    
    public func load() {
        products.removeAll()
        interactor.load()
    }
    
    private func showEmptyStub() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.updateEmtyStubState(this.products.isEmpty)
            this.delegate.updateUI()
        }
    }
}

extension FavouritesPresenter: FavouritesPresenterDelegate {
    
    public func update(_ product: ProductModel?) {
        guard let product = product else {
            showEmptyStub()
            return
        }
        
        guard !products.contains(where: { $0.id == product.id }) else { return }
        products.append(product)
        
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.updateEmtyStubState(this.products.isEmpty)
            this.delegate.updateUI()
        }
    }
}

extension FavouritesPresenter: PresenterProtocol {
    public var countOfProducts: Int {
        return products.count
    }
    
    public func productAt(_ index: Int) -> ProductModel {
        return products[index]
    }
    
    public func handleCellAction(with productId: Int) {
        interactor.handleCellAction(with: productId)
    }
}
