//
//  OtherProductsCVCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class OtherProductsCVCell: UICollectionViewCell {

    // UI elements
    @IBOutlet private weak var productImage: CachedImage!
    
    // Services
    
    private var product: OtherProductModel!
    
    public static let identifier = "OtherProductsCVCell"
    private static let nibName = "OtherProductsCVCell"
    
    public static func register(in collection: UICollectionView) {
        
        let nib = UINib.init(nibName: nibName, bundle: Bundle.main)
        collection.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = UIColor.CustomColors.burgundy
        
        productImage.layer.borderWidth = 1.0
        productImage.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        productImage.layer.cornerRadius = 5.0
        productImage.backgroundColor = UIColor.CustomColors.burgundy
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = 5.0
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        
        layer.borderWidth = 1.0
        layer.borderColor = UIColor.CustomColors.yellow.cgColor
        
        clipsToBounds = false
    }
}

extension OtherProductsCVCell: OtherProductCardProtocol {
    
    public var height: CGFloat {
        return 320.0
    }
    
    public var width: CGFloat {
        return 320.0
    }
    
    public func update(imageContainer: ImageContainerModel) {
        productImage.clear()
        productImage.setupImage(id: imageContainer.id, url: imageContainer.imageLink)
    }
}
