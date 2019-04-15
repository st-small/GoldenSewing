//
//  ProductsCollectionView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/13/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class ProductsCollectionView: UICollectionView {
    
    public var heightValue: CGFloat {
        let height = cellsFactory.size.height
        let count = CGFloat(presenter.countOfProducts())
        return count * (height + minimumLineSpacing) + minimumLineSpacing
    }
    
    private var presenter: ProductsPresenter!
    private let cellsFactory = ProductsCellFactory()
    private let minimumLineSpacing: CGFloat = 12.0
    
    public init(presenter: ProductsPresenter) {
        
        self.presenter = presenter
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        
        ProductsHorizontalCVCell.register(in: self)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = minimumLineSpacing
        contentInset = UIEdgeInsets(top: minimumLineSpacing, left: 0, bottom: minimumLineSpacing, right: 0)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductsCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = presenter.productAt(indexPath.row)
        //presenter.handleCellAction(with: place.id)
    }
}

extension ProductsCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.countOfProducts()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellsFactory.createInCollection(collectionView, for: indexPath) as! ProductCardProtocol
        let product = presenter.productAt(indexPath.row)
        cell.update(product: product)
        return cell as! UICollectionViewCell
    }
}

extension ProductsCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cellsFactory.size
        return CGSize(width: size.width, height: size.height)
    }
}
