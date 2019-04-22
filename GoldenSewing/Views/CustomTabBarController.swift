//
//  CustomTabBarController.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 24.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

public protocol TabsControllerProtocol {
    func focusOn(_ tab: TabsPages)
}

public class CustomTabBarController: UITabBarController {
    
    private var tabs: [TabsPages: UIViewController] = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barStyle = UIBarStyle.black
        self.tabBar.barTintColor = UIColor.CustomColors.burgundy
        self.tabBar.unselectedItemTintColor = UIColor.CustomColors.lightYellow
        
        let categories = CategoriesView()
        categories.tabBarItem = buildTabItem(icon: "categories", title: "Категории")
        tabs[.categories] = categories
        
        let about = AboutUsView()
        about.tabBarItem = buildTabItem(icon: "AboutUsTabBarIcon", title: "О нас")
        tabs[.aboutUs] = about
        
        self.viewControllers = [
            categories, about]
        
        downTabLabels()
        focusOn(.categories)
    }
    
    private func buildTabItem(icon: String, title: String) -> UITabBarItem {
        return UITabBarItem(title: title, image: loadImage(named: icon), selectedImage: loadImage(named: icon))
    }
    
    private func loadImage(named: String) -> UIImage {
        return UIImage(named: named)!
    }
    
    private func downTabLabels() {
        let mainColor = UIColor.CustomColors.yellow
        for item in self.tabBar.items ?? [UITabBarItem]() {
            
            item.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -6, right: 0)
            item.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: mainColor], for: .selected)
        }
        
        tabBar.isTranslucent = false
        tabBar.tintColor = mainColor
        
        addShadowToBar()
    }
    
    private func addShadowToBar() {
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        tabBar.layer.shadowRadius = 4.0
        tabBar.layer.shadowOpacity = 1.0
        tabBar.layer.masksToBounds = false
    }
}

extension CustomTabBarController: TabsControllerProtocol {
    public func focusOn(_ tab: TabsPages) {
        
        let vc = tabs[tab]!
        self.selectedIndex = (self.viewControllers?.index(where: { $0 === vc })!)!
    }
}
