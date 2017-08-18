//
//  ProductsTVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

fileprivate struct C {
    struct CellHeight {
        static let close: CGFloat = 106 // equal or greater foregroundView height
        static let open: CGFloat = 500 // equal or greater containerView height
    }
}

class ProductsTVC: UITableViewController, UISearchBarDelegate {
    
    // MARK: - Outlets -
    //@IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Properties -
    var categoryID = 0
    var categoryTitle = ""
    var productsArray = [Product]()
    var kbFrameSize: CGRect?
    
    var cellHeights = [CGFloat]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set naviagtion label
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 44))
        label.backgroundColor = .clear
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = UIColor.CustomColors.yellow
        label.text = categoryTitle
        self.navigationItem.titleView = label
        
        self.refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        self.refreshControl?.tintColor = UIColor.CustomColors.yellow
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        tableView.tableFooterView = UIView()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = C.CellHeight.close
        
        // set custom back button
        let customButton = UIBarButtonItem(image: UIImage(named: "back button"), style: .plain, target: self, action: #selector(backButtonTapped))
        customButton.tintColor = UIColor.CustomColors.yellow
        self.navigationItem.leftBarButtonItem = customButton
        
        // set custom back button2
        let customButton2 = UIBarButtonItem(image: UIImage(named: "back button"), style: .plain, target: self, action: nil)
        customButton2.tintColor = .clear
        self.navigationItem.rightBarButtonItem = customButton2
        
        //searchBar.returnKeyType = UIReturnKeyType.done
        
        registerForKeyboardNotifications()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        //self.searchBar.isHidden = true
        loadData()
        //tableView.setContentOffset(CGPoint(x: 0, y: 44), animated: true)
        cellHeights = (0..<productsArray.count).map { _ in C.CellHeight.close }
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // start check if post is modified
        checkModifiedSettingsForPost(startElement: 0, endElement: 9)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.searchBar.endEditing(true)
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
        //self.tableViewBottom.constant = kbFrameSize.height
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Table view data source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductTVCell
        //cell.configureCell(productsArray[indexPath.row], category: categoryID)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! UnfoldingCell
        cell.configureCell(productsArray[indexPath.row], category: categoryID)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //tableView.setContentOffset(CGPoint(x: 0, y: 24), animated: true)
        //tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        // comment this part to use folding cell feature - start -
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        //        vc.product = productsArray[indexPath.row]
        //        vc.modalPresentationStyle = .overCurrentContext
        //        self.present(vc, animated: true, completion: nil)
        // - end -
        
        // UNcomment this part to use folding cell feature - start -
        guard case let cell as UnfoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        var duration = 0.0
        if cellHeights[indexPath.row] == C.CellHeight.close { // open cell
            cellHeights[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: { _ in
                let offset = CGPoint(x: 0, y: cell.frame.minY - 64)
                self.tableView.setContentOffset(offset, animated: true)
            })
            duration = 0.5
        } else {// close cell
            cellHeights[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        // - end -
    }
    
    // MARK: - For folding cell feature methods: -
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let foldingCell as UnfoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                foldingCell.unfold(false, animated: false, completion: nil)
            } else {
                foldingCell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - SearchBar -
    //    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
    //        searchBar.showsCancelButton = true
    //        tableView.reloadData()
    //        return true
    //    }
    //
    //    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    //
    //        if searchBar.text == nil || searchBar.text == "" {
    //            self.searchBar.isHidden = true
    //            self.searchBar.endEditing(true)
    //            tableView.reloadData()
    //
    //        } else {
    //
    //            if (searchBar.text?.isNumber)! {
    //                productsArray = Product.findProductBy(categoryID: categoryID, ID: Int(searchBar.text!)!, orString: "")
    //            } else {
    //                productsArray = Product.findProductBy(categoryID: categoryID, ID: 0, orString: searchBar.text!)
    //            }
    //
    //            tableView.reloadData()
    //        }
    //    }
    //
    //    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    //        searchBar.showsCancelButton = false
    //        loadData()
    //        tableView.setContentOffset(CGPoint(x: 0, y: -24), animated: true)
    //    }
    //
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        self.searchBar.isHidden = true
    //        self.searchBar.endEditing(true)
    //        searchBar.text = ""
    //        loadData()
    //        tableView.setContentOffset(CGPoint(x: 0, y: -24), animated: true)
    //    }
    
    // MARK: - Private methods -
    //    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    //
    //        if (velocity.y > 0) {
    //
    //            let view = UIView()
    //            view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 20)
    //            view.backgroundColor = UIColor.CustomColors.burgundy
    //            self.navigationController?.view.addSubview(view)
    //            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
    //                self.searchBar.isHidden = true
    //                //print("self.tableViewTop.constant \(self.tableViewTop.constant)")
    //                self.navigationController?.setNavigationBarHidden(true, animated: true)
    //            }, completion: nil)
    //
    //        } else if (velocity.y < 0) {
    //
    //            UIView.animate(withDuration: 0.3, delay: 0, options: UIViewAnimationOptions(), animations: {
    //                //print("self.tableViewTop.constant \(self.tableViewTop.constant)")
    //                self.searchBar.isHidden = false
    //                self.navigationController?.setNavigationBarHidden(false, animated: true)
    //            }, completion: nil)
    //        }
    //
    //    }
    
    @objc private func loadData() {
        productsArray = Product.getProductsByParentCategory(productCatID: categoryID)
        DispatchQueue.main.async {
            self.productsArray.sort { ($0.edited)! > ($1.edited)! }
            self.tableView.reloadData()
        }
        self.refreshControl?.endRefreshing()
    }
    
    func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func checkModifiedSettingsForPost(startElement: Int, endElement: Int) {
        // check last checking more than 10 days ago
        let moc = CoreDataStack.instance.persistentContainer.viewContext
        let category = ProductCategory.getPRCategoryBy(ID: categoryID, context: moc)
        let checkDate10DaysAgo = NSDate().addingTimeInterval(-10*24*60*60)
        if let updateDate = category?.lastUpdate {
            if updateDate < checkDate10DaysAgo {
                var index = 0
                let veryEndElement = min(Int(productsArray.count)-1, endElement)
                if !productsArray.isEmpty {
                    for product in productsArray[startElement...veryEndElement] {
                        PersistentService.getServerPostBy(Int(product.id), callback: {
                            index += 1
                            print("index \(index)")
                            if index == 10 && Int(self.productsArray.count) > veryEndElement {
                                print("start \(startElement), end \(veryEndElement)")
                                self.checkModifiedSettingsForPost(startElement: startElement + 9, endElement: veryEndElement+10)
                            }
                        })
                    }
                }
                
                category?.lastUpdate = Date() as NSDate
                try? moc.save()
            }
        }
    }
    
}
