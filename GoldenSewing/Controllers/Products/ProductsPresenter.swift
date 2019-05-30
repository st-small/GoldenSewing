//
//  ProductsPresenter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol ProductsViewDelegate: class {
    func showLoader()
    func hideLoader()
    func reload()
    func problemWithRequest()
    func showNoResult(_ text: String)
    func hideToasts()
}

public class ProductsPresenter {
    
    public weak var delegate: ProductsViewDelegate?
    
    private var products = [ProductModel]()
    private var searchText = ""
    private var interactor: ProductsInteractor!
    
    public init(with categoryId: Int, delegate: ProductsViewDelegate) {
        
        self.delegate = delegate
        self.interactor = ProductsInteractor(with: categoryId, delegate: self)
    }
    
    public func categoryTitle() -> String {
        return interactor.categoryTitle()
    }
    
    public func load(_ searchValue: String = "") {
        showLoader()
        
        searchText = searchValue
        guard !searchValue.isEmpty else {
            interactor.load()
            return
        }
        
        interactor.search(with: searchValue)
    }
    
    public func needReload() {
        interactor.needReload()
    }
    
    public func goBack() {
        interactor.goBack()
    }
    
    private func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate?.showLoader()
        }
    }
    
    private func update(_ data: [ProductModel]) {
        self.products = data.sorted(by: { $0.id > $1.id })
        
        DispatchQueue.main.async { [weak self] in
            
            guard let this = self else {
                return
            }
            
            this.delegate?.reload()
            
            guard !data.isEmpty else { return }
            this.delegate?.hideLoader()
        }
    }
    
    private func hideToasts() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate?.hideToasts()
        }
    }
}

extension ProductsPresenter: ProductsPresenterDelegate {
    public func update(with data: [ProductModel]) {
        hideToasts()
        
        guard searchText.isEmpty else {
            DispatchQueue.main.async { [weak self] in
                guard let this = self else { return }
                this.delegate?.hideLoader()
            }
            return
        }
        update(data)
    }
    
    public func problemWithRequest() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate?.problemWithRequest()
            this.delegate?.hideLoader()
        }
    }
    
    public func updateSearchResults(with data: [ProductModel]) {
        hideToasts()
        products.removeAll()
        update(data)
    }
}

extension ProductsPresenter: PresenterProtocol {
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
