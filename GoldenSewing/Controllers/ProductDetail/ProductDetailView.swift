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
    private var hideSelectedCell: Bool = false
    
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
    
    private func updateImage(_ isShow: Bool) {
        self.productImage.alpha = isShow ? 1.0 : 0.25
    }
    
    @objc func didTapImageView(_ tap: UITapGestureRecognizer) {
        guard let _ = productImage.image else { return }
        presenter.showImagePreview(with: self)
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
        let previewView = presented as! ImageModalViewer
        guard let image = productImage.image else { return nil }
        transition.setupImageTransition(image: image, fromDelegate: self, toDelegate: previewView)
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let previewView = dismissed as! ImageModalViewer
        guard let image = productImage.image else { return nil }
        transition.setupImageTransition(image: image, fromDelegate: previewView, toDelegate: self)
        return transition
    }
}

extension ProductDetailView: ImageTransitionProtocol {
    
    public func tranisitionSetup() {
        updateImage(false)
        //photosCollectionView.reloadData()
    }
    
    public func tranisitionCleanup() {
        updateImage(true)
        //photosCollectionView.reloadData()
    }
    
    public func imageWindowFrame() -> CGRect {
        let current = self.view.convert(productImage.frame, to: self.view.superview)
//        let customY = current.minY + 64.0
//        let rect = CGRect(x: current.minX, y: customY, width: current.width, height: current.height)
        return current
    }
}
