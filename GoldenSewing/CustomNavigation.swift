//
//  CustomNavigation.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CustomNavigation: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = .black
        self.navigationBar.barTintColor = UIColor.CustomColors.burgundy
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.CustomColors.yellow, NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!]
        self.navigationBar.layer.shadowColor = UIColor.black.cgColor
        self.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        self.navigationBar.layer.shadowRadius = 4.0
        self.navigationBar.layer.shadowOpacity = 1.0
        self.navigationBar.layer.masksToBounds = false

    }
}
