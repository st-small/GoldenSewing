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
    
    // Data
    private var imagesArray = [UIImage]()
    private var labelsArray = [String]()
    private var allImagesScrollViews = [UIScrollView]()
    
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
        let imageNames = ["Onboard_1", "Onboard_2", "Onboard_3", "Onboard_4"]
        
        imageNames.forEach { name in
            guard let image = UIImage(named: name) else { return }
            imagesArray.append(image)
        }
    }
    
    private func preapreLabels() {
        labelsArray = [
            "Мы рады приветствовать Вас в нашем приложении. Предлагаем ознакомиться с основными возможностями!", "Экран «Категории» предлагает Вам выбор разделов с нашей продукцией. Выбирайте интересующий раздел.", "Используйте «Поиск» для удобного и быстрого отображения, интересующих Вас изделий.", "Используйте «Поиск» в выбранной категории, используя название или номер артикула."]
    }
    
    private func configureScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.trailing.equalToSuperview()
        }
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
        let buttonView = UIButton()
        buttonView.backgroundColor = UIColor.CustomColors.burgundy
        buttonView.layer.borderWidth = 1.0
        buttonView.layer.borderColor = UIColor.CustomColors.yellow.cgColor
        buttonView.layer.cornerRadius = corners
        
        let title = attributesForString("Пропустить")
        buttonView.setAttributedTitle(title, for: .normal)
        buttonView.addTarget(self, action: #selector(skipTutorial), for: .touchUpInside)
        self.view.addSubview(buttonView)
        
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.snp.remakeConstraints { make in
            make.width.equalTo(screen.width - 32.0)
            make.height.equalTo(44.0)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16.0)
        }
    }
    
    private func attributesForString(_ text: String) -> NSAttributedString {
        
        // font
        let font = UIFont.systemFont(ofSize: 17.0)
        
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
    
    @objc public func skipTutorial() {
        onCompleteHandler?()
    }
}

extension OnboardingView: UIScrollViewDelegate {
    
}

extension OnboardingView: LaunchControllerDelegate {
    
    public var notNeedDisplay: Bool {
        return false
        //return properties.bool(forKey: "onboardingIsShown")
    }
    
    public func hiddenProcessing() { }
}
