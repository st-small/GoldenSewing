//
//  ProductsVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 19.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import AVFoundation

fileprivate struct C {
    struct CellHeight {
        static let close: CGFloat = 106 // equal or greater foregroundView height
        static let open: CGFloat = 500 // equal or greater containerView height
    }
}

class ProductsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    // MARK: - Properties -
    var categoryID = 0
    var categoryTitle = ""
    var productsArray = [Product]()
    var searchArray = [Product]()
    var kbFrameSize: CGRect?
    var isSearch: Bool = false
    var isKBShown: Bool = false
    var cellHeights = [CGFloat]()
    var hidingNavBarManager: HidingNavigationBarManager?
    lazy var searchBar: UISearchBar = UISearchBar()
    var extensionView: UIView!
    var value: IndexPath?
    var refresh = UIRefreshControl()
    //var sound: AVAudioPlayer!

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
        
        // add refreshControl to tableView
        refresh.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)
        refresh.tintColor = UIColor.CustomColors.yellow
        refresh.attributedTitle = NSAttributedString(string: "Обновляем данные", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName:UIColor.CustomColors.yellow])
        hidingNavBarManager?.refreshControl = refresh
        tableView.addSubview(refresh)
        
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
        
        registerForKeyboardNotifications()
        
        // set view for searchBar
        extensionView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        extensionView.backgroundColor = UIColor.CustomColors.burgundy
        
        // set UISearchBar
        searchBar.searchBarStyle = UISearchBarStyle.prominent
        
        //searchBar.searchText
        searchBar.placeholder = " Поиск по артикулу или наименованию..."
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.tintColor = UIColor.CustomColors.yellow
        searchBar.barTintColor = UIColor.CustomColors.burgundy
        searchBar.delegate = self
        extensionView.addSubview(searchBar)
        
        hidingNavBarManager = HidingNavigationBarManager(viewController: self, scrollView: tableView)
        hidingNavBarManager?.addExtensionView(extensionView)
        
        if let tabBar = navigationController?.tabBarController?.tabBar {
            hidingNavBarManager?.manageBottomBar(tabBar)
            tabBar.barTintColor = UIColor.CustomColors.burgundy
        }
        
        // set sound
//        let path = Bundle.main.path(forResource: "pop", ofType: "mp3")
//        let soundURL = URL(fileURLWithPath: path!)
//        do {
//            try sound = AVAudioPlayer(contentsOf: soundURL)
//            sound.prepareToPlay()
//        } catch let err as NSError {
//            print(err.debugDescription)
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hidingNavBarManager?.viewWillAppear(animated)
        loadData()
        tableView.reloadData()
        
        if value != nil {
            tableView.scrollToRow(at: value!, at: .top, animated: true)

        }
    }
    
    override func viewDidLayoutSubviews()  {
        super.viewDidLayoutSubviews()
        hidingNavBarManager?.viewDidLayoutSubviews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hidingNavBarManager?.viewWillDisappear(animated)
    }
    
    
    deinit {
        removeKeyboardNotifications()
    }
    
    // MARK: - Keyboard methods -
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        self.kbFrameSize = kbFrameSize
        tableViewBottom.constant = kbFrameSize.height - 49
        UIView.animate(withDuration:0.3) {
            self.view.layoutIfNeeded()
        }
        
        isKBShown = true
    }
    
    func kbWillHide() {
        UIView.animate(withDuration:0.3) {
            if self.isKBShown {
                self.tableViewBottom.constant -= CGFloat((self.kbFrameSize?.height)!)
            }
        }
        self.isKBShown = false
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearch {
            return searchArray.count
        } else {
            return productsArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell3", for: indexPath) as! UnfoldingCell
        
        if isSearch {
            cell.configureCell(searchArray[indexPath.row], category: categoryID)
        } else {
            cell.configureCell(productsArray[indexPath.row], category: categoryID)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // UNcomment this part to use folding cell feature - start -
        guard case let cell as UnfoldingCell = tableView.cellForRow(at: indexPath) else {
            return
        }
        
        cell.bigImg.tag = indexPath.row
        cell.bigImg.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action:#selector (imageTapped))
        cell.bigImg.addGestureRecognizer(tapRecognizer)
        
        var duration = 0.0
        if cellHeights[indexPath.row] == C.CellHeight.close { // open cell
            hideShowTabBar()
            let offsetValue: CGFloat = (hidingNavBarManager?.currentState)! == HidingNavigationBarState.Open ? 64 : 24
            cellHeights[indexPath.row] = C.CellHeight.open
            cell.unfold(true, animated: true, completion: { _ in
                self.extensionView.isHidden = true
                let offset = CGPoint(x: 0, y: cell.frame.minY - offsetValue)
                self.tableView.setContentOffset(offset, animated: true)
                self.value = indexPath
            })
            duration = 0.5
        } else {// close cell
            hideShowTabBar()
            self.extensionView.isHidden = false
            let offsetValue: CGFloat = (hidingNavBarManager?.currentState)! == HidingNavigationBarState.Open ? 104 : 24
            let offset = CGPoint(x: 0, y: cell.frame.minY - offsetValue)
            self.tableView.setContentOffset(offset, animated: true)
            cellHeights[indexPath.row] = C.CellHeight.close
            cell.unfold(false, animated: true, completion: nil)
            duration = 1.1
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { _ in
            tableView.beginUpdates()
            if duration > 1.0 {
                self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            }
            tableView.endUpdates()
        }, completion: nil)
        // - end -
    }
    
    // MARK: - For folding cell feature methods: -
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if case let foldingCell as UnfoldingCell = cell {
            if cellHeights[indexPath.row] == C.CellHeight.close {
                foldingCell.unfold(false, animated: false, completion: nil)
            } else {
                foldingCell.unfold(true, animated: false, completion: nil)
            }
        }
    }
    
    // MARK: - SearchBar -
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        isSearch = true
        searchBar.showsCancelButton = true
        tableView.reloadData()
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            isSearch = false
            self.searchBar.endEditing(true)
            tableView.reloadData()
            
        } else {
            
            if (searchBar.text?.isNumber)! {
                searchArray = Product.findProductBy(categoryID: categoryID, ID: Int(searchBar.text!)!, orString: "")
            } else {
                searchArray = Product.findProductBy(categoryID: categoryID, ID: 0, orString: searchBar.text!)
            }
            
            tableView.reloadData()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        loadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        self.searchBar.endEditing(true)
        searchBar.text = ""
        loadData()
    }



    // MARK: - Private methods -
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        hidingNavBarManager?.shouldScrollToTop()
        return true
    }
    
    @objc private func loadData() {
        productsArray = Product.getProductsByParentCategory(productCatID: categoryID)
        cellHeights = (0..<productsArray.count).map { _ in C.CellHeight.close }
        DispatchQueue.main.async {
            if !self.productsArray.isEmpty {
                self.productsArray.sort { ($0.edited)! > ($1.edited)! }
            }
            self.tableView.reloadData()
        }
        //playSound()
        refresh.endRefreshing()
    }
    
//    func playSound() {
//        if sound.isPlaying {
//            sound.stop()
//        }
//        sound.play()
//    }
    
    func backButtonTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func imageTapped(gestureRecognizer: UITapGestureRecognizer) {
        searchBar.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        let product = isSearch ? searchArray[(gestureRecognizer.view?.tag)!] : productsArray[(gestureRecognizer.view?.tag)!]
        //print("tag is \(gestureRecognizer.view?.tag)")
        vc.product = product
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        present(vc, animated: true, completion: nil)
    }
    
    func hideShowTabBar() {
        let boolValue = (tabBarController?.tabBar.isHidden)!
        tabBarController?.tabBar.isHidden = boolValue ? false : true
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
