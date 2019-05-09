//
//  ProductDetailPresenter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/17/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation
import UIKit

public protocol ProductDetailViewDelegate {
    func showLoader()
    func hideLoader()
    func reload(data: ProductModel)
    func updateLike(_ isLiked: Bool)
    func problemWithRequest()
    func hideToasts()
}

public class ProductDetailPresenter {
   
    public var delegate: ProductDetailViewDelegate
    private var interactor: ProductDetailInteractor!
    
    public init(with productId: Int, delegate: ProductDetailViewDelegate) {
        
        self.delegate = delegate
        self.interactor = ProductDetailInteractor(with: productId, delegate: self)
    }
    
    public func load() {
        showLoader()
        interactor.load()
        interactor.checkIsLiked()
    }
    
    public func productTitle() -> String {
        return interactor.productTitle()
    }
    
    public func showImagePreview(with transitionDelegate: UIViewControllerTransitioningDelegate) {
        interactor.showImagePreview(with: transitionDelegate)
    }
    
    public func like() {
        interactor.like()
    }
    
    public func goBack() {
        interactor.goBack()
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

extension ProductDetailPresenter: ProductDetailPresenterDelegate {
    
    public func update(with data: ProductModel) {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.reload(data: data)
            this.delegate.hideLoader()
        }
    }
    
    public func updateLike(_ isLiked: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate.updateLike(isLiked)
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
