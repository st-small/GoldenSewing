//
//  ProductCardProtocol.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/13/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public protocol ProductCardProtocol {
    
    var height: CGFloat { get }
    var width: CGFloat { get }
    
    func update(product: ProductModel)
}
