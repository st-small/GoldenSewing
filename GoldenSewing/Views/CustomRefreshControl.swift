//
//  CustomRefreshControl.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 4/25/19.
//  Copyright © 2019 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import AVFoundation

public class CustomRefreshControl: UIRefreshControl {
    
    public override init() {
        super.init()
        tintColor = UIColor.CustomColors.yellow
    }
    
    public override func endRefreshing() {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + 1.5) {
            super.endRefreshing()
        }
    }
    
    public func setTitle(_ value: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.CustomColors.yellow
        ]
        attributedTitle = NSAttributedString(string: value, attributes: attributes)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
