//
//  OtherProductsPresenter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol OtherProductsViewDelegate {
    func showLoader()
    func hideLoader()
    func reload()
    func problemWithRequest()
    func hideToasts()
}

public class OtherProductsPresenter {
    
    public var delegate: OtherProductsViewDelegate
    
    private var product = OtherProductModel()
    private var interactor: OtherProductsInteractor!
    
    public init(with categoryId: Int, delegate: OtherProductsViewDelegate) {
        
        self.delegate = delegate
        self.interactor = OtherProductsInteractor(with: categoryId, delegate: self)
    }
    
    public func categoryTitle() -> String {
        return interactor.categoryTitle()
    }
    
    public func load() {
        showLoader()
        interactor.load()
    }
    
    public func goBack() {
        interactor.goBack()
    }
    
    public func countOfProducts() -> Int {
        return product.imageContainers.count
    }
    
    public func imageAt(_ index: Int) -> ImageContainerModel {
        return product.imageContainers[index]
    }
    
    public func select(_ product: ProductModel) {
        
    }
    
    public func getDescription() -> String {
        return interactor.getDescription()
    }
    
    private func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.showLoader()
        }
    }
    
    private func hideToasts() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.hideToasts()
        }
    }
}

extension OtherProductsPresenter: OtherProductsPresenterDelegate {
    public func update(with data: OtherProductModel) {
        hideToasts()
        self.product = data

        DispatchQueue.main.async { [weak self] in

            guard let this = self else {
                return
            }

            this.delegate.reload()

            guard !this.product.imageContainers.isEmpty else { return }
            this.delegate.hideLoader()
        }
    }
    
    public func problemWithRequest() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.problemWithRequest()
            this.delegate.hideLoader()
        }
    }
}
