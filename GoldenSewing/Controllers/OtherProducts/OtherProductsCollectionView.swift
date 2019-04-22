//
//  OtherProductsCollectionView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class OtherProductsCollectionView: UICollectionView {

    public var heightValue: CGFloat {
        let height = cellsFactory.size.height
        let count = CGFloat(presenter.countOfProducts())
        return count * (height + minimumLineSpacing) + minimumLineSpacing
    }
    
    private var presenter: OtherProductsPresenter!
    private let cellsFactory = OtherProductsCellFactory()
    private let minimumLineSpacing: CGFloat = 12.0
    
    public init(presenter: OtherProductsPresenter) {
        
        self.presenter = presenter
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)
        
        backgroundColor = .clear
        delegate = self
        dataSource = self
        
        OtherProductsCVCell.register(in: self)
        
        translatesAutoresizingMaskIntoConstraints = false
        layout.minimumLineSpacing = minimumLineSpacing
        contentInset = UIEdgeInsets(top: minimumLineSpacing,
                                    left: minimumLineSpacing,
                                    bottom: minimumLineSpacing,
                                    right: minimumLineSpacing)
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OtherProductsCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let product = presenter.imageAt(indexPath.row)
        //presenter.handleCellAction(with: place.id)
    }
}

extension OtherProductsCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.countOfProducts()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = cellsFactory.createInCollection(collectionView, for: indexPath) as! OtherProductCardProtocol
        let image = presenter.imageAt(indexPath.row)
        cell.update(imageContainer: image)
        return cell as! UICollectionViewCell
    }
}

extension OtherProductsCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = cellsFactory.size
        return CGSize(width: size.width, height: size.height)
    }
}
