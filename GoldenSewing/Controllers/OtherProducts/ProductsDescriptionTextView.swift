//
//  ProductsDescriptionTextView.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/17/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class ProductsDescriptionTextView: UITextView {
    
    private var presenter: OtherProductsPresenter!
    
    public init(presenter: OtherProductsPresenter) {
        self.presenter = presenter
        super.init(frame: .zero, textContainer: nil)
        
        initialize()
    }
    
    private func initialize() {
        self.text = presenter.getDescription()
        self.textAlignment = .center
        self.backgroundColor = .clear
        self.textColor = UIColor.CustomColors.yellow
        self.font = getFontValue()
        self.isScrollEnabled = false
        self.isEditable = false
        self.isSelectable = false
        
        resize()
    }
    
    private func getFontValue() -> UIFont {
        switch UIScreen.main.bounds.width {
        case 320:
            return .systemFont(ofSize: 13.0)
        case 375:
            return .systemFont(ofSize: 14.0)
        case 414:
            return .systemFont(ofSize: 15.0)
        default:
            return .systemFont(ofSize: 12.0)
        }
    }
    
    private func resize() {
        var newFrame = self.frame
        let width = newFrame.size.width
        let newSize = self.sizeThatFits(CGSize(width: width, height: CGFloat.greatestFiniteMagnitude))
        newFrame.size = CGSize(width: width, height: newSize.height)
        self.frame = newFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
