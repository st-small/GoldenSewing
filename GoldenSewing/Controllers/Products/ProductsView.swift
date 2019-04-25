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
    private var searchBar: UISearchBar!
    
    private var refresh: CustomRefreshControl!
    
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
        configureSearchBar()
        configureCollectionView()
        configureRefresh()
    }
    
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "Back", in: Bundle.main, compatibleWith: nil), style: .plain, target: self, action: #selector(goBack))
        
        let searchButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let iconImage = UIImage(named: "Search")?.withRenderingMode(.alwaysTemplate)
        searchButton.tintColor = UIColor.CustomColors.yellow
        searchButton.setBackgroundImage(iconImage, for: .normal)
        searchButton.addTarget(self, action: #selector(searchActionTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: searchButton)
        
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
    
    private func configureSearchBar() {
        searchBar = UISearchBar()
        searchBar.barTintColor = UIColor.CustomColors.burgundy
        self.view.addSubview(searchBar)
        updateSearchBarConstraints(false)
        
        searchBar.delegate = self
    }
    
    private func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.leading.bottom.equalToSuperview()
        }
    }
    
    private func configureRefresh() {
        refresh = CustomRefreshControl()
        refresh.setTitle("Обновление данных")
        collectionView.refreshControl = refresh
        
        refresh.addTarget(self, action: #selector(needReload), for: .valueChanged)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.load()
    }
    
    @objc private func goBack() {
        presenter.goBack()
    }
    
    @objc private func searchActionTapped() {
        let show = !(searchBar.frame.height > 0)
        if !show {
            presenter.load()
        }
        updateSearchBarConstraints(show)
    }
    
    private func updateSearchBarConstraints(_ show: Bool) {
        let height = show ? 56.0 : 0
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.searchBar.snp.remakeConstraints { make in
                make.top.leading.trailing.equalToSuperview()
                make.height.equalTo(height)
            }
            self?.searchBar.superview?.layoutIfNeeded()
        }
    }
    
    @objc private func needReload() {
        presenter.needReload()
    }
}

extension ProductsView: UISearchBarDelegate {
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        presenter.load()
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.load()
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        presenter.load()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            presenter.load()
            return
        }
        presenter.search(with: searchText)
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
        refresh.endRefreshing()
        collectionView.reloadData()
    }
    
    public func problemWithRequest() {
        let errorMessage = "Проблемы с получением данных. Проверьте подключение интернет."
        self.view.makeToast(errorMessage)
    }
    
    public func showNoResult(_ text: String) {
        let errorMessage = "По Вашему запросу \"\(text)\" ничего не найдено."
        self.view.makeToast(errorMessage, duration: 30.0, position: .center)
    }
    
    public func hideToasts() {
        self.view.hideAllToasts()
    }
}
