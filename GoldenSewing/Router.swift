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
}
