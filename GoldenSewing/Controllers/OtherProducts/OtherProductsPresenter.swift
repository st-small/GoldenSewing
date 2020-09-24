//
//  OtherProductsPresenter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public protocol OtherProductsViewDelegate {
    func showLoader()
    func hideLoader()
    func reload()
    func problemWithRequest()
    func hideToasts()
    func showPreview(product: [ImageContainerModel], index: Int)
}

public class OtherProductsPresenter {
    
    public var delegate: OtherProductsViewDelegate
    public var selectedIndex: Int!
    
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
    
    public func currentImageLink() -> String? {
        guard
            let imageLink = product.imageContainers[selectedIndex].imageLink else { return nil }
        return imageLink
    }
    
    public func select(_ productIndex: Int) {
        selectedIndex = productIndex
        delegate.showPreview(product: product.imageContainers, index: selectedIndex)
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
    public func update(with data: OtherProductModel?) {
        
        guard let data = data else { return }
        hideToasts()
        
        if self.product.modified < data.modified {
            self.product = data
        }

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

extension OtherProductsPresenter: OtherProductsModalDelegate {
    public func updateSelectedIndex(newIndex: Int) {
        selectedIndex = newIndex
    }
}
