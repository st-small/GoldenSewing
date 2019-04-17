//
//  ProductDetailView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/17/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class ProductDetailView: UIViewController {

    // UI elements
    @IBOutlet private weak var productImage: CachedImage!
    
    // Data
    private var productId: Int!
    private var presenter: ProductDetailPresenter!
    
    private let transition = PopAnimator()
    
    public init(productId: Int) {
        super.init(nibName: "ProductDetailView", bundle: Bundle.main)
        
        self.productId = productId
        presenter = ProductDetailPresenter(with: productId, delegate: self)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        configureNavigationBar()
        
        productImage.backgroundColor = .clear
        productImage.layer.cornerRadius = 10.0
        productImage.layer.borderWidth = 1.0
        productImage.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapImageView)))
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
        label.text = presenter.productTitle()
        self.navigationItem.titleView = label
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.load()
    }
    
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        presenter.showImagePreview(with: self)
//        let herbDetails = UIViewController()
//        herbDetails.view.backgroundColor = .red
//        herbDetails.transitioningDelegate = self
//        present(herbDetails, animated: true, completion: nil)
    }
    
    @objc private func goBack() {
        presenter.goBack()
    }
}

extension ProductDetailView: ProductDetailViewDelegate {
    public func showLoader() {
        self.view.makeToastActivity(.center)
    }
    
    public func hideLoader() {
        self.view.hideToastActivity()
    }
    
    public func reload(data: ProductModel) {
        guard let container = data.imageContainer else { return }
        self.productImage.setupImage(id: data.id, url: container.imageLink)
    }
    
    public func problemWithRequest() {
        let errorMessage = "Проблемы с получением данных. Проверьте подключение интернет."
        self.view.makeToast(errorMessage)
    }
    
    public func hideToasts() {
        self.view.hideAllToasts()
    }
}

extension ProductDetailView: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = productImage.superview!.convert(productImage.frame, to: nil)
        
        transition.presenting = true
        productImage.isHidden = true
        
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}
