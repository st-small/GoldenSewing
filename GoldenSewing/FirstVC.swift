//
//  FirstVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class FirstVC: UIViewController {
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        
        PersistentService.getProductCategories { (prCat) in
            //print(prCat)
            for category in prCat {
                print("Func FirstVC 'getProductCategories' -> category name - \(category.name) and category posts count is \(category.postsCount)")
            }
            //PersistentService.getProductsByParent(categoryID: 6, callback: { (products) in
                //print("\nEnd checking category \(6) There are \(products.count) posts")
            //})

            DispatchQueue.main.async {
               self.openCategoriesVC()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    // MARK: - Navigation -
    func startOnboardingTutorial() {
        
    }
    
    func openCategoriesVC() {
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "CategoriesTVC") as! CategoriesTVC
        let nav = UINavigationController(rootViewController: vC)
        self.present(nav, animated: true, completion: nil)
    }
    
    func tempVC() {
        let vC = self.storyboard?.instantiateViewController(withIdentifier: "ProductsTVC") as! ProductsTVC
        let nav = UINavigationController(rootViewController: vC)
        self.present(nav, animated: true, completion: nil)
    }
    
    
    // MARK: - Private Methods -
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // check if app first launched
    
    
}
