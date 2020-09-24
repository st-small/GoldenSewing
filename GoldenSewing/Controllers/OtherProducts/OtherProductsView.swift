//
//  OtherProductsView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/16/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import Toast_Swift

public class OtherProductsView: UIViewController {

    // UI elements
    private var scrollView: UIScrollView!
    private var collectionView: OtherProductsCollectionView!
    private var descriptionView: ProductsDescriptionTextView!
    
    // Data
    private var categoryId: Int!
    private var presenter: OtherProductsPresenter!
    
    private let transition = PopAnimator()
    private var hideSelectedCell: Bool = false
    
    public init(categoryId: Int) {
        super.init(nibName: "OtherProductsView", bundle: Bundle.main)
        
        self.categoryId = categoryId
        presenter = OtherProductsPresenter(with: categoryId, delegate: self)
        
        scrollView = UIScrollView()
        collectionView = OtherProductsCollectionView(presenter: presenter)
        descriptionView = ProductsDescriptionTextView(presenter: presenter)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        configureNavigationBar()
        configureScrollView()
        configureCategoryDescriptionView()
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
    
    private func configureScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
    }
    
    private func configureCategoryDescriptionView() {
        scrollView.addSubview(descriptionView)
        descriptionView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(15.0)
            make.leading.equalTo(self.view.snp.leading).offset(15.0)
            make.trailing.equalTo(self.view.snp.trailing).offset(-15.0)
        }
    }
    
    private func configureCollectionView() {
        let height = OtherProductsCellFactory().size.width * 2 + 36
        scrollView.addSubview(collectionView)
        collectionView.snp.remakeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(15.0)
            make.leading.equalTo(self.view.snp.leading)
            make.trailing.equalTo(self.view.snp.trailing)
            make.bottom.equalToSuperview().offset(-30.0)
            make.height.equalTo(height)
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

extension OtherProductsView: OtherProductsViewDelegate {
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
    
    public func hideToasts() {
        self.view.hideAllToasts()
    }
    
    public func showPreview(product: [ImageContainerModel], index: Int) {
        let previewView = OtherProductsModal()
        previewView.transitioningDelegate = self
        previewView.setupWithPhotos(photos: product, selectedPhotoIndex: index, delegate: presenter)
        present(previewView, animated: true, completion: nil)
    }
}

extension OtherProductsView: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let previewView = presented as! OtherProductsModal
        guard let imageLink = presenter.currentImageLink() else { return nil }
        transition.setupImageTransition(imageLink: imageLink, fromDelegate: self, toDelegate: previewView)
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let previewView = dismissed as! OtherProductsModal
        guard let imageLink = presenter.currentImageLink() else { return nil }
        transition.setupImageTransition(imageLink: imageLink, fromDelegate: previewView, toDelegate: self)
        return transition
    }
}

extension OtherProductsView: ImageTransitionProtocol {
    public func tranisitionSetup() {
        hideSelectedCell = true
        //collectionView.reloadData()
    }
    
    public func tranisitionCleanup() {
        hideSelectedCell = false
        //collectionView.reloadData()
    }
    
    public func imageWindowFrame() -> CGRect {
        let indexPath = IndexPath(row: presenter.selectedIndex!, section: 0)
        let attributes = collectionView.layoutAttributesForItem(at: indexPath as IndexPath)
        var cellRect = collectionView.convert(attributes!.frame, to: collectionView.superview)
        
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        let navBarHeight = navigationController?.navigationBar.bounds.height ?? 0
        let value = (statusBarHeight + navBarHeight) - scrollView.contentOffset.y
        cellRect.origin.y += value
        return cellRect
    }
}
