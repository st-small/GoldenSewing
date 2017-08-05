//
//  ProductsTVC.swift
//  GoldenSewing
//
//  Created by Stanly Shiyanovskiy on 31.07.17.
//  Copyright © 2017 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class ProductsTVC: UITableViewController {
    
    // MARK: - Properties -
    var categoryID = 0
    var categoryTitle = ""
    var productsArray = Set<Product>()
    let productsNames = ["Митра 1", "Митра 2", "Митра 3", "Митра 4", "Митра 5"]
    let productsImages = ["1", "2", "3", "4", "5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = categoryTitle
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
    }

    // MARK: - Table view data source -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ProductTVCell
        var tempArr = [Product]()
        tempArr.append(contentsOf: productsArray)
        cell.configureCell(tempArr[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "detailSegue" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let dvc = segue.destination as! DetailVC
//                dvc.imageName = self.productsImages[indexPath.row]
//            }
//        }
    }

}
