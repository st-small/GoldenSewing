//
//  NavigationController.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 11/20/18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public class NavigationController: UINavigationController { 
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        print("Main navigation controller load.")
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = UIColor.CustomColors.burgundy
        
        navigationBar.titleTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: UIColor.CustomColors.yellow, NSAttributedString.Key.font.rawValue: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!])
        
        addShadowToBar()
    }
    
    private func addShadowToBar() {
        navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationBar.layer.shadowRadius = 4.0
        navigationBar.layer.shadowOpacity = 1.0
        navigationBar.layer.masksToBounds = false
    }
}

extension NavigationController {
    private func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
        guard let input = input else { return nil }
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
    }
}

