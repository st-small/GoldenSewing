//
//  Router.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class Router {
    
    public static let shared = Router()
    
    private init() { }
    
    public var navigator: NavigationController!
    public var tabs: (TabsControllerProtocol & UITabBarController)!
    
    public func goBack(animated: Bool = true) {
        navigator?.popViewController(animated: animated)
    }
    
    public func openProductsWithCategory(_ id: Int) {
        let products = ProductsView(categoryId: id)
        navigator?.pushViewController(products, animated: true)
    }
}
