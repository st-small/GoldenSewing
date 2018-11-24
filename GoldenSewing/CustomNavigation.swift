//
//  CustomNavigation.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class CustomNavigation: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = .black
        self.navigationBar.barTintColor = .green//UIColor.CustomColors.burgundy
        
    }
    
    public override func loadView() {
        super.loadView()
        
        
    }
}


