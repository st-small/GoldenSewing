//
//  OnboardingView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 5/15/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class OnboardingView: UIViewController {
    
    public var onCompleteHandler: Trigger?
    
    // UI elements
    private var scrollView: UIScrollView!
    private var contentView: UIView!
    private var enterAction: UIButton!
    
    // Data
    private var imagesArray = [UIImage]()
    private var labelsArray = [String]()
    private var allImagesScrollViews = [UIScrollView]()
    
    // Services
    private let deviceService = DeviceService.shared
    
    private var screen: CGSize {
        let app = UIApplication.shared
        let statusBar = app.statusBarFrame.height
        let bottomBar = app.keyWindow?.safeAreaInsets.bottom ?? 0
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height - statusBar - bottomBar
        return CGSize(width: width, height: height)
    }
    
    private var contentHeight: CGFloat {
        return screen.height - 60.0
    }
    
    private var imageHeight: CGFloat {
        return contentHeight/3 * 2
    }
    
    private var corners: CGFloat {
        return screen.width/30.0
    }
    
    public override func loadView() {
        super.loadView()
        
        preapreImages()
        preapreLabels()
        configureScrollView()
        configureContentView()
        setupImageViews()
        addSkipButton()
        
        guard let image = UIImage(named: "Background") else { return }
        self.view.backgroundColor = UIColor(patternImage: image)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func preapreImages() {
        let imageNames = Constants.onboardingImages
        
        imageNames.forEach { name in
            guard let image = UIImage(named: name) else { return }
            imagesArray.append(image)
        }
    }
    
    private func preapreLabels() {
        labelsArray = Constants.onboardingLabels
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
        
        scrollView.accessibilityElementsHidden = false
        scrollView.accessibilityIdentifier = "OnboardingScroll"
    }
    
    private func configureContentView() {
        contentView = UIView()
        self.scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let widthValue: CGFloat = CGFloat(imagesArray.count) * screen.width
        contentView.snp.remakeConstraints { make in
            make.top.bottom.leading.trailing.equalTo(contentView.superview!)
            make.width.equalTo(widthValue)
            make.height.equalTo(contentHeight)
        }
    }
    
    private func setupImageViews() {
        
        var previousView: UIView = contentView
        
        for x in 0 ..< imagesArray.count {
            
            let image = imagesArray[x]
            let label = labelsArray[x]
            
            // create sub scrollview
            let subScrollView = UIScrollView()
            subScrollView.delegate = self
            contentView.addSubview(subScrollView)
            allImagesScrollViews.append(subScrollView)
            
            // create container
            let containerView = UIView()
            containerView.backgroundColor = UIColor.CustomColors.burgundy
            containerView.layer.borderWidth = 1.0
            containerView.layer.borderColor = UIColor.CustomColors.yellow.cgColor
            containerView.layer.cornerRadius = corners
            subScrollView.addSubview(containerView)
            
            // create imageview
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            containerView.addSubview(imageView)
            
            // create label view
            let labelView = UILabel()
            labelView.attributedText = attributesForString(label)
            labelView.numberOfLines = 0
            labelView.textAlignment = .center
            containerView.addSubview(labelView)
            
            // add subScrollView constraints
            subScrollView.translatesAutoresizingMaskIntoConstraints = false
            subScrollView.snp.remakeConstraints { make in
                if x == 0 {
                    make.leading.equalTo(previousView.snp.leading)
                } else {
                    make.leading.equalTo(previousView.snp.trailing)
                }
                make.top.bottom.equalTo(contentView)
                make.width.equalTo(scrollView.snp.width)
            }
            
            // add container constraints
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.snp.remakeConstraints { make in
                make.top.equalTo(contentView).offset(16.0)
                make.bottom.equalTo(contentView).offset(-16.0)
                make.centerX.equalToSuperview()
                make.width.equalTo(screen.width - 32.0)
            }
            
            // add imageview constraints
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.snp.remakeConstraints { make in
                make.height.equalTo(imageHeight)
                make.width.equalTo(imageView.snp.height).multipliedBy(image.size.width / image.size.height)
                make.centerX.equalTo(containerView.snp.centerX)
                make.top.equalTo(containerView.snp.top).offset(16.0)
            }
            
            // add label view constraints
            labelView.translatesAutoresizingMaskIntoConstraints = false
            labelView.snp.remakeConstraints { make in
                make.width.equalTo(containerView).offset(-20.0)
                make.centerX.equalToSuperview()
                make.top.equalTo(imageView.snp.bottom).offset(16.0)
                make.bottom.equalTo(containerView).offset(-16.0)
            }
            
            // set as previous
            previousView = subScrollView
        }
    }
    
    private func addSkipButton() {
        enterAction = UIButton()
        enterAction.backgroundColor = UIColor.CustomColors.burgundy
        enterAction.layer.borderWidth = 1.0
        enterAction.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        enterAction.layer.cornerRadius = corners
        
        let title = attributesForString("Пропустить")
        enterAction.setAttributedTitle(title, for: .normal)
        enterAction.addTarget(self, action: #selector(skipTutorial), for: .touchUpInside)
        self.view.addSubview(enterAction)
        
        enterAction.translatesAutoresizingMaskIntoConstraints = false
        enterAction.snp.remakeConstraints { make in
            make.width.equalTo(screen.width - 32.0)
            make.height.equalTo(44.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
    }
    
    private func attributesForString(_ text: String) -> NSAttributedString {
        
        // font
        var font = UIFont()
        if screen.width == 320.0 {
            font = UIFont.systemFont(ofSize: 13.0)
        } else if screen.width == 375.0 {
            font = UIFont.systemFont(ofSize: 15.0)
        } else {
            font = UIFont.systemFont(ofSize: 17.0)
        }
        
        // shadow
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.black
        shadow.shadowBlurRadius = 5
        shadow.shadowOffset = CGSize(width: 1, height: 2)
        
        // paragraph
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        paragraphStyle.firstLineHeadIndent = 5.0
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: UIColor.CustomColors.yellow,
            .shadow: shadow,
            .paragraphStyle: paragraphStyle
        ]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    private func updateEnterActionTitle() {
        UIView.animate(withDuration: 0.9) {
            let title = self.attributesForString("Вход")
            self.enterAction.setAttributedTitle(title, for: .normal)
        }
    }
    
    @objc public func skipTutorial() {
        onCompleteHandler?()
    }
}

extension OnboardingView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let widthValue: CGFloat = CGFloat(imagesArray.count) * screen.width - screen.width
        if scrollView == self.scrollView {
            if scrollView.contentOffset.x >= widthValue {
                updateEnterActionTitle()
            }
        }
    }
}

extension OnboardingView: LaunchControllerDelegate {
    
    public var notNeedDisplay: Bool {
        return deviceService.launchIndex != 0
    }
}
