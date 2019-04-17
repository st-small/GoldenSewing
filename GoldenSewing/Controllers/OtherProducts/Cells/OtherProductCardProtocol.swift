//
//  OtherProductCardProtocol.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public protocol OtherProductCardProtocol {
    
    var height: CGFloat { get }
    var width: CGFloat { get }
    
    func update(imageContainer: ImageContainerModel)
}
