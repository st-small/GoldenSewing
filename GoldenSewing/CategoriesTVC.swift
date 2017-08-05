//
//  CategoriesTVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 01.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CategoriesTVC: UITableViewController {
    
    // MARK: - Outlets -
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties -
    var categories = [ProductCategory]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // navigation controller customization
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.barTintColor = UIColor.CustomColors.burgundy
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.CustomColors.yellow, NSFontAttributeName: UIFont(name: "HelveticaNeue-Medium", size: 15.0)!]
        navigationController?.navigationBar.layer.shadowColor = UIColor.black.cgColor
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        navigationController?.navigationBar.layer.shadowRadius = 4.0
        navigationController?.navigationBar.layer.shadowOpacity = 1.0
        navigationController?.navigationBar.layer.masksToBounds = false

        // tableView customization
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        tableView.tableFooterView = UIView()
        
        // get datasource for tableView
        categories = ProductCategory.getPRCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = true
        self.tableView.setContentOffset(CGPoint(x: 0, y: -1 * searchBar.frame.height), animated: true)
        
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoriesTVCell
        cell.configureCell((categories[indexPath.row].name!), tag: (Int(categories[indexPath.row].id)))
        //cell.btn.frame = CGRect(x: 5, y: 5, width: 500, height: 500)
        return cell
    }
    
    // MARK: - Private methods -
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(velocity.y>0) {
            let view = UIView()
            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
            view.backgroundColor = UIColor.CustomColors.burgundy
            self.navigationController?.view.addSubview(view)
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.searchBar.isHidden = true
                //self.tableView.setContentOffset(CGPoint.zero, animated: true)
                self.navigationController?.setNavigationBarHidden(true, animated: true)
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 2.5, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.searchBar.isHidden = false
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                //print("Unhide")
            }, completion: nil)    
        }
   }
    
    // MARK: - Navigation
    @IBAction func btnPressed(_ sender: UIButton) {
        print("button pressed \(sender.tag)")
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsTVC") as! ProductsTVC
        vc.categoryID = sender.tag
        vc.categoryTitle = (sender.titleLabel?.text!)!
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
