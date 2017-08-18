//
//  CategoriesVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 07.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class CategoriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    // MARK: - Properties -
    var categories = [ProductCategory]()
    var searchResults = [Product]()
    var isInSearchMode = false
    var kbFrameSize: CGRect?
    var hidingNavBarManager: HidingNavigationBarManager?
    lazy var searchBar: UISearchBar = UISearchBar()

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
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 85.0
        
        // get datasource for tableView
        categories = ProductCategory.getPRCategories()
        
        registerForKeyboardNotifications()

        // set view for searchBar
        let extensionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        extensionView.backgroundColor = UIColor.CustomColors.burgundy
        
        // set UISearchBar
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        let font = UIFont(name: "Avenir", size: 12)!
        let attributes = [
            NSForegroundColorAttributeName: UIColor.CustomColors.yellow,
            NSFontAttributeName : font]
        searchBar.attributedPlaceholder = NSAttributedString(string: "Type something",
                                                             attributes:attributes)
        searchBar.searchText
        //searchBar.placeholder = " Поиск по артикулу или наименованию..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.barTintColor = UIColor.CustomColors.burgundy
        //searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        extensionView.addSubview(searchBar)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.addExtensionView(extensionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
    }
    
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //navigationController?.setNavigationBarHidden(false, animated: true)
        hidingNavBarManager?.viewWillDisappear(animated)
    }

    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Keyboard methods -
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.kbFrameSize = kbFrameSize
        self.tableViewBottom.constant = kbFrameSize.height
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isInSearchMode {
            return searchResults.count
        }
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isInSearchMode {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as! ProductTVCell
            cell.configureCell(searchResults[indexPath.row], category: 0)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CategoriesTVCell
            cell.configureCell((categories[indexPath.row].name!), tag: (Int(categories[indexPath.row].id)))
            return cell
        }
    }
    
    // MARK: - SearchBar -
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isInSearchMode = true
        searchBar.showsCancelButton = true
        tableView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
//            isInSearchMode = false
//            self.searchBar.isHidden = true
//            tableViewTop.constant = -64
//            self.searchBar.endEditing(true)
//            tableView.reloadData()
            
        } else {
            
//            isInSearchMode = true
//            if (searchBar.text?.isNumber)! {
//                searchResults = Product.findProductBy(categoryID: 0, ID: Int(searchBar.text!)!, orString: "")
//            } else {
//                searchResults = Product.findProductBy(categoryID: 0, ID: 0, orString: searchBar.text!)
//            }

            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        tableViewBottom.constant = 0
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isInSearchMode = false
//        self.searchBar.isHidden = true
//        tableViewTop.constant = -64
//        self.searchBar.endEditing(true)
//        searchBar.text = ""
//        searchResults.removeAll()
//        tableView.reloadData()
    }
    
    // MARK: - Private methods -
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        return true
    }
    
    // MARK: - Navigation
    @IBAction func btnPressed(_ sender: UIButton) {
        if sender.tag == 101 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MetallonitVC") as! MetallonitVC
            vc.categoryID = sender.tag
            //vc.categoryTitle = (sender.titleLabel?.text!)!
            self.navigationController?.pushViewController(vc, animated: true)
        } else if sender.tag == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MetallonitVC") as! MetallonitVC
            vc.categoryID = sender.tag
            //vc.categoryTitle = (sender.titleLabel?.text!)!
            self.navigationController?.pushViewController(vc, animated: true)
        } else if sender.tag == 18 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "MetallonitVC") as! MetallonitVC
            vc.categoryID = sender.tag
            //vc.categoryTitle = (sender.titleLabel?.text!)!
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsTVC") as! ProductsTVC
            vc.categoryID = sender.tag
            vc.categoryTitle = (sender.titleLabel?.text!)!
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard !searchResults.isEmpty else { return }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        vc.product = searchResults[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        //self.searchBar.isHidden = true
    }


}
