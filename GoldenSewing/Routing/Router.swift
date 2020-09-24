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
        var productsView: UIViewController
        
        switch id {
        case 1, 18:
            productsView = OtherProductsView(categoryId: id)
        default:
            productsView = ProductsView(categoryId: id)
        }
        
        navigator?.pushViewController(productsView, animated: true)
    }
    
    public func openDetailView(productId: Int) {
        let detailVC = ProductDetailView(productId: productId)
        navigator?.pushViewController(detailVC, animated: true)
    }
    
    public func showImagePreview(_ id: Int) {
        let imagePreview = ImageModalViewer(productId: id)
        imagePreview.modalPresentationStyle = .overFullScreen
        navigator?.present(imagePreview, animated: true)
    }
    
    public func showImagePreview(_ id: Int, with transitionDelegate: UIViewControllerTransitioningDelegate) {
        let imagePreview = ImageModalViewer(productId: id)
        imagePreview.transitioningDelegate = transitionDelegate
        navigator?.present(imagePreview, animated: true, completion: nil)
    }
}
