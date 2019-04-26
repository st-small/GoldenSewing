//
//  ProductsCellFactory.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/13/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class ProductsCellFactory {
    
    public var size: CGSize {
        let width = UIScreen.main.bounds.width - 32
        switch UIScreen.main.bounds.width {
        case 320.0, 375.0:
            return CGSize(width: width, height: 90)
        case 414.0:
            return CGSize(width: 175.0, height: 233.0)
        default: return CGSize.zero
        }
    }
    
    public func createInCollection(_ collection: UICollectionView, for path: IndexPath) -> UICollectionViewCell {
        switch UIScreen.main.bounds.width {
        case 320.0, 375.0:
            let cell = collection.dequeueReusableCell(withReuseIdentifier: ProductsHorizontalCVCell.identifier, for: path) as! ProductsHorizontalCVCell
            cell.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            cell.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            return cell
        case 414.0:
            let cell = collection.dequeueReusableCell(withReuseIdentifier: ProductsSquareCVCell.identifier, for: path) as! ProductsSquareCVCell
            cell.heightAnchor.constraint(equalToConstant: size.height).isActive = true
            cell.widthAnchor.constraint(equalToConstant: size.width).isActive = true
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

