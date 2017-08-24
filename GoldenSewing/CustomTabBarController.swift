//
//  CustomTabBarController.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 24.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.barTintColor = UIColor.CustomColors.burgundy
        self.tabBar.tintColor = UIColor.CustomColors.yellow
        self.tabBar.unselectedItemTintColor = UIColor.CustomColors.lightYellow
    }
}
