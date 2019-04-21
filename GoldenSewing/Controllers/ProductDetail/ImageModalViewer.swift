//
//  ImageModalViewer.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/18/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import RealmSwift

public class ImageModalViewer: UIViewController {
    
    // UI elements
    private var closeAction: UIButton!
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    
    // Data
    private var productId: Int
    private var allPhotoScrollViews: Array<UIScrollView> = []
    private var allPhotos: Array<UIImage> = []
    private var scrollViewDragging: Bool = false
    private var currentPhotoIndex: Int = 0
    
    // Services
    let realm = try! Realm()
    
    public init(productId: Int) {
        self.productId = productId
        super.init(nibName: "ImageModalViewer", bundle: Bundle.main)
        
        prepareSourceImages()
    }
    
    private func prepareSourceImages() {
        guard
            let post = realm.objects(ProductModelRealmItem.self).filter({ $0.id == self.productId }).first,
            let imageData = post.imageContainer?.imageData,
            let image = UIImage(data: imageData) else { return }
        allPhotos.append(image)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = .black
        
        configureScrollView()
        configureContentView()
        setupImageViews()
        configureCloseButton()
    }
    
    private func configureCloseButton() {
        closeAction = UIButton()
        closeAction.setImage(UIImage(named: "close"), for: .normal)
        closeAction.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        self.scrollView.addSubview(closeAction)
        
        closeAction.snp.remakeConstraints { make in
            make.top.equalTo(self.topLayoutGuide.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().offset(-10.0)
            make.height.width.equalTo(24.0)
        }
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        self.view.addSubview(scrollView)
        
        scrollView.snp.remakeConstraints { make in
            make.size.equalToSuperview()
        }
        
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(backButtonTapped))
        upSwipe.direction = .up
        scrollView.addGestureRecognizer(upSwipe)
    }
    
    private func configureContentView() {
        contentView = UIView()
        self.scrollView.addSubview(contentView)
        
        let screenWidth = UIScreen.main.bounds.width
        let widthValue: CGFloat = CGFloat(allPhotos.count) * screenWidth
        contentView.snp.remakeConstraints { make in
            make.top.bottom.trailing.leading.height.equalToSuperview()
            make.width.equalTo(widthValue)
        }
    }
    
    private func setupImageViews() {
        
        var previousView: UIView = contentView
        for x in 0...allPhotos.count-1 {
            
            let photo = allPhotos[x]
            
            let subScrollView = UIScrollView()
            subScrollView.delegate = self
            contentView.addSubview(subScrollView)
            allPhotoScrollViews.append(subScrollView)
            
            let imageView = UIImageView(image: photo)
            imageView.contentMode = .scaleAspectFill
            subScrollView.addSubview(imageView)
            
            // add subScrollView constraints
            subScrollView.translatesAutoresizingMaskIntoConstraints = false
            let attribute: NSLayoutConstraint.Attribute = (x == 0) ? .leading : .trailing
            scrollView.addConstraint(NSLayoutConstraint(item: subScrollView, attribute: .leading, relatedBy: .equal, toItem: previousView, attribute: attribute, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: subScrollView, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: subScrollView, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: subScrollView, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1, constant: 0))
            
            // add imageview constraints
            imageView.translatesAutoresizingMaskIntoConstraints = false
            subScrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: imageView, attribute: .height, multiplier: (photo.size.width / photo.size.height), constant: 0))
            subScrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: subScrollView, attribute: .centerX, multiplier: 1, constant: 0))
            subScrollView.addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: subScrollView, attribute: .centerY, multiplier: 1, constant: 0))
            
            // add imageview side constraints
            for attribute: NSLayoutConstraint.Attribute in [.top, .bottom, .leading, .trailing] {
                let constraintLowPriority = NSLayoutConstraint(item: imageView, attribute: attribute, relatedBy: .equal, toItem: subScrollView, attribute: attribute, multiplier: 1, constant: 0)
                let constraintGreaterThan = NSLayoutConstraint(item: imageView, attribute: attribute, relatedBy: .greaterThanOrEqual, toItem: subScrollView, attribute: attribute, multiplier: 1, constant: 0)
                constraintLowPriority.priority = UILayoutPriority(rawValue: 750)
                subScrollView.addConstraints([constraintLowPriority,constraintGreaterThan])
            }
            
            previousView = subScrollView
        }
        scrollView.contentOffset = CGPoint.zero
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        view.backgroundColor = UIColor.black
    }
    
    private func getCurrentPageIndex() -> Int {
        return Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
    }
    
    @objc func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
}

extension ImageModalViewer: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            scrollViewDragging = true
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView {
            scrollViewDragging = false
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView && scrollViewDragging {
            currentPhotoIndex = getCurrentPageIndex()
        }
    }
}

extension ImageModalViewer: ImageTransitionProtocol {
    
    public func tranisitionSetup() {
        scrollView.isHidden = true
    }
    
    public func tranisitionCleanup() {
        scrollView.isHidden = false
        let xOffset = CGFloat(currentPhotoIndex) * scrollView.frame.size.width
        scrollView.contentOffset = CGPoint(x: xOffset, y: 0)
    }
    
    public func imageWindowFrame() -> CGRect {
        
        let photo = allPhotos[currentPhotoIndex]
        let scrollWindowFrame = scrollView.superview!.convert(scrollView.frame, to: nil)
        
        let scrollViewRatio = scrollView.frame.size.width / scrollView.frame.size.height
        let imageRatio = photo.size.width / photo.size.height
        let touchesSides = (imageRatio > scrollViewRatio)
        
        if touchesSides {
            let height = scrollWindowFrame.size.width / imageRatio
            let yPoint = scrollWindowFrame.origin.y + (scrollWindowFrame.size.height - height) / 2
            return CGRect(x: scrollWindowFrame.origin.x, y: yPoint, width: scrollWindowFrame.size.width, height: height)
        } else {
            let width = scrollWindowFrame.size.height * imageRatio
            let xPoint = scrollWindowFrame.origin.x + (scrollWindowFrame.size.width - width) / 2
            return CGRect(x: xPoint, y: scrollWindowFrame.origin.y, width: width, height: scrollWindowFrame.size.height)
        }
    }
}
