//
//  OtherProductsCellFactory.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class OtherProductsCellFactory {
    
    public var size: CGSize {
        let width = (UIScreen.main.bounds.width - 32 - 12)/2
        switch UIScreen.main.bounds.width {
        default: return CGSize(width: width, height: width)
        }
    }
    
    public func createInCollection(_ collection: UICollectionView, for path: IndexPath) -> UICollectionViewCell {
        let cell = collection.dequeueReusableCell(withReuseIdentifier: OtherProductsCVCell.identifier, for: path) as! OtherProductsCVCell
        cell.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        cell.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        return cell
    }
}
