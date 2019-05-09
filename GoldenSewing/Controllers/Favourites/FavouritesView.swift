//
//  FavouritesView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 5/7/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class FavouritesView: UIViewController {
    
    // UI elements
    private var emtyStub: UIView!
    private var collectionView: ProductsCollectionView!
    
    private var presenter: FavouritesPresenter!
    
    public init() {
        super.init(nibName: "FavouritesView", bundle: Bundle.main)
        
        presenter = FavouritesPresenter(with: self)
        collectionView = ProductsCollectionView(presenter: presenter)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        configureEmptyListStub()
        configureCollectionView()
    }
    
    private func configureEmptyListStub() {
        emtyStub = UIView()
        emtyStub.backgroundColor = UIColor.CustomColors.burgundy
        self.view.addSubview(emtyStub)
        
        emtyStub.translatesAutoresizingMaskIntoConstraints = false
        emtyStub.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        let label = UILabel()
        label.text = "К сожалению, Вы еще не добавили в \"Избранное\" ни одного изделия."
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = UIColor.CustomColors.yellow
        emtyStub.addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.snp.remakeConstraints { make in
            make.center.equalTo(emtyStub.snp.center)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().offset(-16.0)
        }
    }
    
    private func configureCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.navigationItem.title = "Избранное"
        presenter.load()
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension FavouritesView: FavouritesViewDelegate {
    public func updateEmtyStubState(_ isShow: Bool) {
        
        UIView.animate(withDuration: 0.3) {
            let alpha: CGFloat = isShow ? 1.0 : 0
            self.emtyStub.alpha = alpha
        }
    }
    
    public func updateUI() {
        collectionView.reloadData()
    }
}
