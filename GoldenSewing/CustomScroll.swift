//
//  CustomScroll.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 21.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CustomScroll: UIScrollView {

    override func draw(_ rect: CGRect) {
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
        self.minimumZoomScale = 1
        self.maximumZoomScale = 4.0
        self.zoomScale = 1.0
        
        self.layer.borderColor = UIColor.green.cgColor
        self.layer.borderWidth = 2.0
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
    }


}
