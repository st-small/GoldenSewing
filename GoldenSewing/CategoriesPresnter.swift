//
//  CategoriesPresnter.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/24/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import Foundation


public protocol CategoriesViewDelegate { 
    func reload()
    func problemWithRequest()
    
    func showLoader()
    func hideLoader()
}

public class CategoriesPresenter {
    
    public var delegate: CategoriesViewDelegate
    
    private var categories = ["Митры", "Облачения", "Скрижали", "Иконы", "Иконостасы", "Разное", "Митры", "Облачения", "Скрижали", "Иконы", "Иконостасы", "Разное"]
    private var interactor: CategoriesInteractor!
    
    public init(with delegate: CategoriesViewDelegate) {
        
        self.delegate = delegate
        self.interactor = CategoriesInteractor(with: self)
    }
    
    // MARK: Interface
    public func load() { }
    public func countOfCategories() -> Int {
        return categories.count
    }
    public func categoryAt(_ index: Int) -> String {
        return categories[index]
    }
    public func select(_ category: String) {
        interactor.toCategory(1345)
    }
}

extension CategoriesPresenter: CategoriesPresenterDelegate {
    public func update(with data: [String]) {
        
    }
    
    public func problemWithRequest() {
        
    }
}
