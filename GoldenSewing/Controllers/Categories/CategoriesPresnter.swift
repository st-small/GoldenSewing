//
//  CategoriesPresnter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation

public protocol CategoriesViewDelegate: class {
    func reload()
    func problemWithRequest()
    
    func showLoader()
    func hideLoader()
}

public class CategoriesPresenter {
    
    public weak var delegate: CategoriesViewDelegate?
    
    private var categories = [CategoryModel]()
    private var interactor: CategoriesInteractor!
    
    public init(with delegate: CategoriesViewDelegate) {
        
        self.delegate = delegate
        self.interactor = CategoriesInteractor(with: self)
    }
    
    // MARK: Interface
    public func load() {
        showLoader()
        interactor.load()
    }
    
    public func needReload() {
        interactor.needReload()
    }
    
    public func countOfCategories() -> Int {
        return categories.count
    }
    
    public func categoryAt(_ index: Int) -> CategoryModel {
        return categories[index]
    }
    
    public func select(_ category: Int) {
        interactor.toCategory(category)
    }
    
    private func showLoader() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate?.showLoader()
        }
    }
}

extension CategoriesPresenter: CategoriesPresenterDelegate {
    public func update(with data: [CategoryModel]) {
        categories = data.sorted(by: { $0.title < $1.title })
        
        DispatchQueue.main.async { [weak self] in
            
            guard let this = self else {
                return
            }
            
            this.delegate?.reload()
            
            guard !data.isEmpty else { return }
            this.delegate?.hideLoader()
        }
    }
    
    public func problemWithRequest() {
        DispatchQueue.main.async { [weak self] in
            guard let this = self else { return }
            this.delegate?.problemWithRequest()
            this.delegate?.hideLoader()
        }
    }
}
