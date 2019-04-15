//
//  ProductsView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 3/30/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import SnapKit
import Toast_Swift

public class ProductsView: UIViewController {
    
    // UI elements
    private var collectionView: ProductsCollectionView!
    
    // Data
    private var categoryId: Int!
    private var presenter: ProductsPresenter!
    
    public init(categoryId: Int) {
        super.init(nibName: "ProductsView", bundle: Bundle.main)
        
        self.categoryId = categoryId
        presenter = ProductsPresenter(with: categoryId, delegate: self)
        
        collectionView = ProductsCollectionView(presenter: presenter)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        configureNavigationBar()
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back", in: Bundle.main, compatibleWith: nil), style: .plain, target: self, action: #selector(goBack))
        
        let screenWidth = UIScreen.main.bounds.width
        let labelWidth = screenWidth - 110
        let label = UILabel(frame: CGRect(x:(screenWidth/2) - (labelWidth/2), y:0, width: labelWidth, height: 50.0))
        label.backgroundColor = .clear
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 13.0)
        label.textAlignment = .center
        label.textColor = UIColor.CustomColors.yellow
        label.text = presenter.categoryTitle()
        self.navigationItem.titleView = label
    }
    
    private func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.load()
    }
    
    @objc private func goBack() {
        presenter.goBack()
    }
}

extension ProductsView: ProductsViewDelegate {
    public func showLoader() {
        self.view.makeToastActivity(.center)
    }
    
    public func hideLoader() {
        self.view.hideToastActivity()
    }
    
    public func reload() {
        collectionView.reloadData()
    }
    
    public func problemWithRequest() {
        let errorMessage = "Проблемы с получением данных. Проверьте подключение интернет."
        self.view.makeToast(errorMessage)
    }
}
