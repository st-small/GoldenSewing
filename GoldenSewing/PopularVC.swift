//
//  PopularVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 26.08.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit
import CoreData

//
// MARK: - Section Data Structure
//
struct Section {
    var name: String
    var products: [Product]
    var collapsed: Bool
    
    init(name: String, products: [Product], collapsed: Bool = false) {
        self.name = name
        self.products = products
        self.collapsed = collapsed
    }
}


class PopularVC: UIViewController, UITableViewDataSource, UITableViewDelegate, PopularHeaderDelegate {
    
    // MARK: - Outlets -
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties -
    var sections = [Section]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Избранное"
        
        tableView.backgroundColor = UIColor(patternImage: UIImage(named: "Background")!)
        tableView.tableFooterView = UIView()
        
        // Auto resizing the height of the cell
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Initialize the sections array
        var starsArray = getProducts(byStar: true)
        starsArray = starsArray.sorted { ($0.rating) > ($1.rating) }
        
        var historyArray = getProducts(byStar: false)
        historyArray = historyArray.sorted { ($0.seen)! > ($1.seen)! }
        
        sections = [
            Section(name: "Отмеченные звёздочкой:", products: starsArray),
            Section(name: "История просмотров:", products: historyArray),
        ]
        
        tableView.reloadData()
    }
    
    func snapshotOfCell(_ inputView: UIView) -> UIView {
        UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, false, 0.0)
        inputView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let cellSnapshot : UIView = UIImageView(image: image)
        cellSnapshot.layer.masksToBounds = false
        cellSnapshot.layer.cornerRadius = 0.0
        cellSnapshot.layer.shadowOffset = CGSize(width: -5.0, height: 0.0)
        cellSnapshot.layer.shadowRadius = 5.0
        cellSnapshot.layer.shadowOpacity = 0.4
        return cellSnapshot
    }

// MARK: - View Controller DataSource and Delegate -

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].collapsed ? 0 : sections[section].products.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailVC") as! DetailVC
        //print("tag is \(gestureRecognizer.view?.tag)")
        vc.product = sections[(indexPath as NSIndexPath).section].products[(indexPath as NSIndexPath).row]
        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.tabBarController?.present(vc, animated: true, completion: nil)
    }
    
    // Cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "Cell2"
        var cell: ProductCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? ProductCell
        if cell == nil {
            tableView.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? ProductCell
        }
        
        let product = sections[(indexPath as NSIndexPath).section].products[(indexPath as NSIndexPath).row]
        let star = indexPath.section == 0 ? true : false
        cell.configureCell(product, category: Int((product.category?.id)!), star: star)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return sections[(indexPath as NSIndexPath).section].collapsed ? 0 : UITableView.automaticDimension
    }
    
    // Header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? PopularHeader ?? PopularHeader(reuseIdentifier: "header")
        
        header.titleLabel.text = sections[section].name
        header.arrowLabel.text = ">"
        header.setCollapsed(sections[section].collapsed)
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

            return 34.0

    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
//
// MARK: - Section Header Delegate -
//
    func toggleSection(_ header: PopularHeader, section: Int) {
        let collapsed = !sections[section].collapsed
        
        // Toggle collapse
        sections[section].collapsed = collapsed
        header.setCollapsed(collapsed)
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
//
// MARK: - Private methods -
//
    func getProducts(byStar: Bool) -> [Product] {
        
        var products = [Product]()
        
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        fetchRequest.predicate = byStar == true ? NSPredicate(format: "rating > 0") : NSPredicate(format: "seen != nil")
        
        do {
            
            products = try CoreDataStack.instance.persistentContainer.viewContext.fetch(fetchRequest)
            
        } catch {
            
            // handle the error
        }
        
        return products
    }
    
}
