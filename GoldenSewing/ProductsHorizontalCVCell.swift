//
//  ProductsHorizontalCVCell.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/13/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class ProductsHorizontalCVCell: UICollectionViewCell {

    // UI elements
    @IBOutlet private weak var productImage: CachedImage!
    @IBOutlet private weak var productName: UILabel!
    @IBOutlet private weak var productVendorCode: UILabel!
    @IBOutlet private weak var productBestOffer: UIImageView!
    
    // Services
    
    private var product: ProductModel!
    
    public static let identifier = "ProductsHorizontalCVCell"
    private static let nibName = "ProductsHorizontalCVCell"
    
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
        productName.textColor = UIColor.CustomColors.yellow
        
        productVendorCode.textColor = UIColor.CustomColors.yellow
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
    
    private func refresh() {
        productImage.clear()
        if let imageContainer = product.imageContainer {
            productImage.setupThumb(id: imageContainer.id, url: imageContainer.thumbnailLink)
        }
        productName.text = product.title
        productVendorCode.text = "Артикул \(product.id)"
        productBestOffer.isHidden = !product.bestOffer
    }
}

extension ProductsHorizontalCVCell: ProductCardProtocol {
    
    public var height: CGFloat {
        return 90.0
    }
    
    public var width: CGFloat {
        return 320.0
    }
    
    public func update(product: ProductModel) {
        self.product = product
        
        refresh()
    }
}
